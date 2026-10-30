# Central Coast V3 Data Pipeline — Progress Report
**Author:** Xue Gao  **Date:** 2026-07-06  **Branch:** `staging-central-coast-data-api-updates-V2`

> 中文说明：本文档主要用英文（方便汇报），中文是给我自己看懂的注释。
> This report is mainly in English for the presentation; Chinese notes are for my own reference.

---

## 1. Summary / 摘要

We received a **new RHESSys output bundle** (a single **WRF** climate scenario for the Central Coast / Rockynook–SBFR sub-watershed) that replaces the retired V2 data. I built a **new, self-contained "CentralCoastV3" import pipeline** that loads this data into a local MySQL database, following David's `ScenarioUpgradeGuide.md` step by step. The **import side (data → database) is complete and verified**. The remaining work is the **read side (API + Unity)**.

> 中文：拿到新的 RHESSys 数据（WRF 单一 scenario），旧的 V2 数据退役。我照 David 的升级指南，新建了一整套独立的 V3 导入流程，把数据灌进本地 MySQL 并验证通过。**导入端做完了**，剩下 **API + Unity 读取端**。

**Key principle / 核心原则:** V3 is built **parallel to V2, never modifying V2** (David's Step 10). V3 is **config-driven** — future scenarios need only a new JSON config file, not new code.

> 中文：V3 和 V2 并行、不动 V2。而且配置驱动——以后新 scenario 只要新配置文件，不用写代码。

---

## 2. The Full Data Pipeline / 完整数据流程

This is the end-to-end path from the climate model to what the user sees in Unity.
（这是从气候模型到 Unity 画面的完整链路，汇报时用这张图解释。）

```
┌─────────────────┐   CSV files   ┌──────────────────────┐   EF Core   ┌─────────────┐
│  RHESSys model  │ ────────────► │   Data Importer      │ ──────────► │   MySQL     │
│  (hydro + fire  │  (per patch,  │  (.NET 8 console app)│  (inserts)  │  database   │
│   simulation)   │   per day)    │  parse / map / load  │             │  (tables)   │
└─────────────────┘               └──────────────────────┘             └──────┬──────┘
                                                                               │ SQL queries
                                                                               ▼
                                   ┌──────────────────────┐   HTTP/JSON  ┌─────────────┐
                                   │   Unity client       │ ◄──────────  │  ASP.NET    │
                                   │  (3D visualization,  │   (REST API) │  Core Web   │
                                   │   timeline, cubes)   │              │  API        │
                                   └──────────────────────┘              └─────────────┘
```

| Stage | What it does | 中文 |
|-------|--------------|------|
| **1. RHESSys model** | Ecohydrology + fire simulation. Outputs daily CSV per patch (vegetation carbon, water, weather, burn). | 生态水文+火模拟，输出每天每 patch 的 CSV |
| **2. Data Importer** | .NET 8 console app. Reads CSVs, maps columns to the DB schema, inserts rows via EF Core. **← my work this cycle** | 导入程序：读 CSV、映射、写库（本次我做的） |
| **3. MySQL** | Stores the processed data in relational tables (`CubeData`, `Dates`). | 存进关系表 |
| **4. Web API** | ASP.NET Core REST API. Serves data to Unity as JSON on request. | 后端 API，按需把数据以 JSON 给 Unity |
| **5. Unity** | Renders the "cubes", timeline, and scenario views the end user interacts with. | 前端 3D 可视化 |

---

## 3. What I Did This Cycle / 本次完成的工作

Built the complete **CentralCoastV3 importer** (Stage 2 above) — all new, isolated classes so V2/BigCreek are untouched:

| Component | File | Purpose | 中文 |
|-----------|------|---------|------|
| Model | `Models/CentralCoastV3/CubeDataRowV3.cs` | Defines the `CubeData` table shape (41 columns) | 表结构定义 |
| DB context | `DAL/CentralCoastV3DbContext.cs` | Owns the V3 tables (`CubeData` + `Dates`) | V3 库上下文 |
| DAL | `DAL/CentralCoastV3DAL.cs` | Chunked insert helpers | 分块写入 |
| Importer | `IO/CentralCoastV3Importer.cs` | Reads CSVs → builds rows → loads (cube, aggregate, dates) | 核心导入逻辑 |
| Validator | `IO/CentralCoastV3Validator.cs` | Pre-import row-count / date-range / zone checks | 导入前校验 |
| Schema | `Database/Schema/CentralCoastV3_schema.sql` | Checked-in DB schema (via migration + mysqldump) | 数据库结构存档 |
| Wiring | `Program.cs`, `Wizard/WizardRunner.cs` | Route V3 profile to the V3 importer | 分发接线 |

**Database:** `futuremtn_central_coast_v3` (local only — never production).
（数据库只在本地，绝不碰生产。）

---

## 4. Verification Results / 验证结果

All data loaded and cross-checked in the local DB:

| Table | Rows | Check | 中文 |
|-------|------|-------|------|
| **CubeData** | **128,568** | 11,688 basin-aggregate rows (`patchID = -1`) + 116,880 per-patch rows (5 display zones) | 聚合行 + patch 行 |
| **Dates** | **11,688** | `id` runs 1…11,688; `id = 1` ↔ `1987-07-01`; aligns 1:1 with `CubeData.dateIdx` | 日期表，id 与 dateIdx 对齐 |
| Fire data | — | `burn`/`fire` columns non-zero on **3,960 rows** (max burn = 15.28) → fire correctly imported | 火数据正确进库 |
| Date range | — | 1987-07-01 → 2019-06-30 (~32 years) | 时间跨度 |

> Talking point / 汇报要点: I verified not just row counts, but that the **aliased columns actually hold values** and that **fire events survived the import** — proving the column mapping is correct, not silently zeroed.

---

## 5. Technical Challenges Solved / 解决的技术难点

These are good discussion points — the V3 CSV format differs from V2 in four ways:
（这四点是 V3 和 V2 数据格式的关键差异，也是汇报的技术亮点。）

1. **Quoted headers / 带引号表头** — V3 CSV headers are `"day","month",...` (V2 was unquoted). The V2 reader would crash on these; V3 strips quotes (`.Trim('"')`).
2. **Column-name aliases / 列名别名** — CSV names ≠ model names (e.g. `GPP_over`→`gppOver`, `RH`→`relHumidity`, `burned`→`burn`). V2's reflection auto-mapping fails here, so V3 maps each column explicitly.
3. **Single-file layout / 单文件布局** — V3 puts hydrology + vegetation + weather + fire in one row; no separate over/under-story files to join (V2 needed a join). Simpler single-pass import.
4. **`warmingIdx` → `scenarioIdx`** — the user-facing dimension is now the *scenario*, not a warming temperature. Renamed via a new optional `ScenarioIdx` config property (V2 keeps `warmingIdx` untouched).

Also solved: the **`dateIdx` alignment** — `CubeData.dateIdx` and `Dates.id` are derived from the same calendar and inserted in ascending order into an empty table, so the API can translate `dateIdx → real date` correctly.

---

## 6. What's Next / 下一步 (Step 10 — API + Unity)

The import side is done; the read side remains:

1. **Point the API at the new DB** (`futuremtn_central_coast_v3`) — port the CubeData/Dates read models & queries.
2. **Rename `warmingIdx` → `scenarioIdx`** on the API and Unity side.
3. **Confirm read/write conventions match** — the API must read basin data by `patchID = -1` and aggregate carbon from the `*Over` fields, exactly as the importer wrote them.
4. **Retire the old DB** and promote the V3 schema to the server (`CentralCoastV3_schema.sql`).
5. **Cleanup (later):** once V2 is retired, delete V2 code, drop the `V3` suffix, extract a shared CSV-parsing helper.

> 中文：导入端完成。接下来把 API 指向新库、改名 scenarioIdx、核对读写约定一致、退役旧库、把 schema 推到服务器；最后清理 V2 代码。

---

## 7. How to Run (Reference) / 运行命令（备查）

From the folder containing `ScenarioConfig_CentralCoastV3.json`:
```bash
# Validate only (no DB writes) / 只校验，不写库
dotnet run -- --auto --config ScenarioConfig_CentralCoastV3.json --cubes --dryrun

# Import dates, then cubes / 先导日期表，再导 cube
dotnet run -- --auto --config ScenarioConfig_CentralCoastV3.json --dates
dotnet run -- --auto --config ScenarioConfig_CentralCoastV3.json --cubes
```
> Note / 注意: V3 requires an explicit category flag (`--dates` / `--cubes`). A bare `--auto` would try not-yet-implemented categories.
> V3 必须显式带分类 flag；裸 `--auto` 会去跑还没实现的类别。

---
---

# Part 2 — Read Side: API + Unity (2026-07-13) / 读取端

> The "What's Next" from Part 1 is now done: the **full pipeline runs end-to-end in Unity** — terrain, trees, water, timeline, and fire all render from V3 data.
> 中文：上半部分的"下一步"完成了。整条链路在 Unity 里跑通：地形、树、水、时间轴、火，全部由 V3 数据驱动渲染。

## 8. Web API — V3 read controllers / V3 读取端 API

New V3-only controllers, each mirroring V2's JSON/DTO shape so Unity needs almost no change. Everything is parallel to V2 (V2/BigCreek untouched).
（每个 controller 都复用 V2 的 DTO 形状，Unity 基本不用改。全部与 V2 并行。）

| Endpoint | Reads from | 中文 |
|----------|-----------|------|
| `api/centralcoastv3/CubeData` | `CubeData` by patch + scenarioIdx + dateIdx | cube 数据 |
| `api/centralcoastv3/Dates` | `Dates` | 日历 |
| `api/centralcoastv3/TerrainData/{scenarioIdx}` | `TerrainData` (generated per month) | 地形网格 |
| `api/centralcoastv3/WaterData/{index}` + `/total` | **CubeData aggregate rows (`patchID = -1`)** — no separate water table | 水/流量（复用聚合行） |
| `api/centralcoastv3/FireData/{scenarioIdx}` | returns empty list (V3 has no terrain fire-spread frames) | 火帧（返回空，见下） |

> Key idea / 核心: `scenarioIdx` is mapped into V2's existing `warmingIdx` DTO field, so the Unity JSON shape is identical → minimal Unity change.
> scenarioIdx 塞进 V2 原有的 warmingIdx 字段，Unity 收到的 JSON 形状不变。

## 9. Terrain — generated, not imported / 地形（生成，非导入）

Terrain is **generated** from the patch pixel-map + monthly vegetation carbon + burn (396×301 grid painted per month). Gotchas solved:
（地形是由 patch 像素图 + 月度植被碳 + 火 生成的，不是导入的。踩的坑：）

- **Integer encoding / 整数编码**: Unity's `_dataList` is `int[]` (value = float × 10^precision). We first stored floats → `JsonReaderException`. Fixed to store `int = round(value × 10⁴)`. Also halved the payload (~195MB → ~100MB).
- **Hardcoded start year / 写死的起始年**: `UpdateTerrain` assumed BigCreek's `startYear = 1942`. Made it profile-aware (Central Coast = 1987, month offset 7).
- **SERI_FireManager needs a square terrain / 火系统要方形地形**: V3 landscape is 396×301 (rectangular) → the landscape-wide fire/splatmap animation crashes. Skipped it for Central Coast (`backgroundSnowOn = false`; profile-guard the landscape `IgniteTerrain` / `fireManager.Initialize`). Cube fire is unaffected (each cube has its own square mini-terrain).

## 10. Water + Timeline / 水 + 时间轴

- Water is served from the **aggregate cube rows** (`patchID = -1`, which hold streamflow/rain) — no separate water table needed.
- **The timeline is built from water data** (`CreateTimelineWeb` uses yearly precip/streamflow). So "no water endpoint" was also "no timeline". Building the water endpoint fixed both.
（时间轴是用水数据画的，所以水端点缺失时时间轴也不显示；补上水端点后两个一起好。）

## 11. Fire — cube fire, data-driven / 火（cube 着火，数据驱动）

The BigCreek fire system was **hardcoded** (demo dates 1969/1988; a manual `switch` of which cube burns). Made it data-driven for V3:
（BigCreek 的火是写死的演示数据，改成 V3 数据驱动。）

- **Fire dates from data / 火日期来自数据**: replaced the 2 hardcoded dates with V3's **11 real fire-start dates** (derived from `fire` column 0→1 transitions), profile-branched.
- **`ShouldBurnFireFromData`**: a cube burns if its own `fire` column is set that day (kept BigCreek's original method untouched; new method + `if (apiProfile == CentralCoastV3)` branch).
- **Index alignment / 索引对齐**: sim `timeIdx` is 0-based, cube data keyed by 1-based `dateIdx` → `+1` when reading.
- **Fire kills plants / 火烧死植物**: `SetVegetationToDieFromFire` already computes kills from a **carbon drop** at the fire day. Fixed a real bug: `ReadData`'s web branch used `AggregateDataColumnIdx` for carbon cases but callers passed `DataColumnIdx` — the two enums differ by one column (aggregate has a single `Trans`, per-patch has `TransOver`+`TransUnder`), so it silently read `stemCOver` instead of `leafCOver`. Fixed by reading **by field name** (`row.leafCOver`) for web, bypassing the column-number enums entirely.

> Talking point / 汇报要点: the column bug is a good example of "**file-era column indices applied to table-era data**" — V3 merged everything into one table, so the old per-file column enums no longer apply. Lesson: **read by field name, not column number.**

## 12. Vegetation — species + patch distribution / 植被（物种 + patch 分布）★ 今天的主线

Central Coast uses different species from BigCreek: **Oak + Chaparral (overstory)**, **Grass (understory)**.
（Central Coast 物种：上层 oak + chaparral，下层 grass——和 BigCreek 的冷杉/灌木不同。）

### 12.1 Species prefabs / 物种模型
- Imported a **coast live oak (Quercus agrifolia)** model (LODGroup + LOD meshes). Fixed several prefab gotchas: the height-measuring code did `GetChild(0).GetComponent<Renderer>()` (fragile) → changed to `GetComponentInChildren<Renderer>()`; a non-oak species was scaled by oak's height (invisible) → fixed `InitializePrefabs(treeList[0]…)` to `treeList[prefabListID]`.
- **Chaparral** reuses David's existing **Manzanita** prefab (a real chaparral shrub, growth stages already built).

### 12.2 Patch structure / patch 结构
From the RHESSys metadata: each cube (= a **Patch Family** = a zone) has **patch 1 and patch 2**, each with its own **overstory species** and **% of Patch Family** (area). **Not always 50/50** — e.g. South is 15% Chaparral / 85% Grass; only Riparian has Oak.

| Cube | Zone | patch1 | patch2 |
|------|------|--------|--------|
| North | 14094 | Chaparral 50% | Chaparral 50% |
| South | 13260 | Chaparral 15% | Grass 85% |
| High | 6487 | Chaparral 50% | Chaparral 50% |
| Low | 18030 | Chaparral 50% | Chaparral 50% |
| Riparian | 20803 | **Oak 50%** | Chaparral 50% |

### 12.3 Implementation / 实现（CubeController.cs）
- `PatchDisplayInfo` config (species + percent) + `patch1`/`patch2` fields; `useCentralCoastPatches` flag turns the feature on **per cube** (BigCreek/aggregate leave it off → original behavior).
- `GrowOverstoryByPatch` grows the overstory as a **per-patch mix**: each patch's plant count = its own carbon × its area % ÷ avg carbon; species chosen by name (`Oak`/`Chaparral`), or grass for grass-dominated patches.
- **Two-member data loading / 加载两个 member**: each cube loads **both** patch members (`patchID` = member 01, plus `patchID + 1` = member 02) into `cubeData` and `cubeDataP2`, so **patch1 is driven by member 01's carbon and patch2 by member 02's** — the correct architecture (not one shared dataset split by area).
- **Async coordination / 异步协调**: the two data requests are async; the vegetation grows **once, only after both members are loaded** (`p1Loaded`/`p2Loaded` flags), otherwise a late second load resets and freezes the growth animation.

### 12.4 BigCreek safety / BigCreek 安全
All of it is gated by `useCentralCoastPatches` (off by default) and null-guards, so **BigCreek and the aggregate cube fall back to the original single-species growth, unchanged.** Decided **against** copying CubeController into a separate CC class (5000-line monolith, would drift out of sync) — the flag+guard pattern is the right isolation.

## 13. Status / 现状

| Piece | Status | 中文 |
|-------|--------|------|
| Importer → DB (5 tables) | ✅ done & verified | 导入端完成 |
| API (cube/dates/terrain/water/fire) | ✅ done | 读取端 API 完成 |
| Unity: terrain / trees / water / timeline | ✅ rendering | 渲染跑通 |
| Fire: cube ignition + plant death | ✅ working | cube 火 + 烧死 |
| Vegetation: oak/chaparral, per-patch %, two-member data | ✅ working | 物种 + patch 分布 + 两 member |
| Fire terrain-spread animation | ⬜ deferred (needs square-terrain rework) | 地形火蔓延（缓） |
| Tree height driven by data `heightOver` | ⬜ idea (currently sized by carbon) | 用数据 height 定树高（想法）|
| Retire old DB / promote schema to server | ⬜ later | 退旧库、推 schema |

> Next idea to explore / 下一个想法: size trees directly from the data's `heightOver` (and detect death from a sudden height drop) instead of the current carbon-based scaling.
> 中文：下一步想试——直接用数据里的 `heightOver` 定树高、用高度骤降判断死亡，替代现在的按碳缩放。

---
---

# Part 3 — Vegetation Dynamics: per-patch balance, riparian structure, death (2026-07-19)
**Branch:** `staging-central-coast-data-api-updates-V3`

> Part 2 got vegetation to *appear* from V3 data. Part 3 is about making it *behave over time* — each patch following its own carbon, trees dying from drought and fire, and the riparian cube reading as a real stream corridor.
> 中文：Part 2 让植被"长出来"，Part 3 让它"随时间正确变化"——每个 patch 跟自己的碳、树会因干旱和火而死、河岸 cube 有真实的溪流格局。

## 14. The core architectural gap found this cycle / 本轮发现的核心架构缺口

Part 2 made **initial** growth per-patch. But everything *after* t=0 was still single-patch:

```csharp
// UpdateVegetation(), every frame after initialisation:
bool spawned = GrowAFir(false);          // ← speciesIdx defaults to 0
```

`GrowOverstoryByPatch` was only ever called once, from `GrowInitialVegetation`. So:

| Symptom | Cause |
|---|---|
| patch2's species frozen at its t=0 count, only ever shrinking | all ongoing growth used species 0; `KillAFir` picked victims **at random across species** |
| Riparian cube saturated at `MaxTrees = 40`, `toKill` permanently 0 | all-species visualised carbon compared against **patch1's raw carbon** — mismatched units |

> Talking point / 汇报要点: this is the same class of bug as the Part 2 column-index issue — **an initialisation-time concept (per-patch) that was never carried into the update loop.** Getting the first frame right is not the same as getting the simulation right.

### 14.1 Fix — a genuine two-patch balance loop / 双 patch 平衡

Each patch now runs its own closed loop against its own data:

| Piece | New API |
|---|---|
| Per-species carbon | `GetTreeCarbonAmountVisualized(int speciesIdx)` |
| Per-species living trees | `GetAliveTrees(int speciesIdx)` |
| Per-species kill queue | `firsToKillBySpecies[]` + `KillAFir(bool, int speciesIdx)` |
| Per-species growth throttle | `lastFirGrownTimeIdxBySpecies[]` |
| The loop itself | `UpdatePatchOverstory(patch, patchCarbonRaw)` |

Each tree now records its own `speciesIdx` (`FirController.speciesIdx`), set at spawn.

**Why the per-species growth throttle matters / 为什么节流器要分物种**: `lastFirGrownTimeIdx` is shared and set by `GrowAFir` on success. Since patch1 is evaluated first, it consumed every growth slot before patch2 was ever offered one — patch1 would starve patch2 indefinitely. Splitting the throttle per species fixes it.

Verified in-game via a new `[PATCHBAL]` log — the Riparian cube now reports both species independently:

```
[PATCHBAL] CubeF sp0(Oak)        viz:0.763 data:1.751 alive:14
[PATCHBAL] CubeF sp1(Chaparral)  viz:0.298 data:0.724 alive:9
```

### 14.2 Fix — planting against carbon *at maturity* / 按成熟碳种植

A subtler defect: the loop compared **current** visualised carbon against the target. A newly planted sapling starts at scale 0 and contributes ≈0 carbon, so the loop planted again the next frame, and again — until the stand was massively overstocked. Once everything matured, carbon overshot and trees were culled. Net effect: **a permanent population of tiny trees plus constant unexplained deaths.**

Measured: trees sat at **13–27% of full size across the entire 32-year timeline.**

Fix — count saplings at what they will be worth:

```csharp
// TreeController
public float GetPotentialCarbonAmount()   // treeFullHeightScale * fullHeight * carbonFactor
// CubeController
GetTreePotentialCarbonVisualized(speciesIdx)   // drives the plant/cull decision
```

Note this deliberately omits `GetCarbonAmount()`'s `localScale.magnitude <= 0` early-out, since a freshly planted tree *is* at zero scale.

> Correction to an earlier hypothesis / 修正之前的判断: I first suspected tree **size** was carbon-driven and double-counting with tree **count**. Reading `TreeController.GrowTree()` disproved it — size grows at a constant `TreeGrowthSpeedFactor`, independent of carbon. The real cause was the sapling accounting above.

## 15. Grass promoted to a real carbon layer / 草升格为碳层

Central Coast's South cube (13260) is **15% Chaparral / 85% Grass** — grass is not decoration there, it is the dominant vegetation. But the inherited code treated grass as scenery:

- `GetShrubCarbonAmountVisualized()` iterates `shrubs` only — **grass carbon was never measured anywhere**
- grass grew on a dice roll (`Random.Range(0,100) <= grassGrowthPercentChance`), nested *inside* the "shrubs are below target" branch — so grass stopped growing the moment shrubs caught up
- initial grass count divided the patch carbon by **`treeAverageCarbonAmount`** (an oak!), producing single-digit grass counts
- background fill was `Random.Range(2, 250)` — a cube's grass density was literally a dice roll

**Central Coast has no shrub layer at all** — Oak and Chaparral are both built as trees (`isShrub = false`), so `shrubPrefabs` is empty, `GetShrubCarbonAmountVisualized()` returns 0, and the understory branch was permanently true. The understory carbon from RHESSys had **no consumer**.

Fix: `UpdateCentralCoastGrass()` balances grass against understory carbon **plus** the grass patch's own overstory carbon, using a new `GetGrassCarbonAmountVisualized()` and a deterministic background fill (`ccBackgroundGrassPatches`).

> ⚠ Data gap / 数据缺口: `CentralCoastV3Rows.cs` has `leafCUnder` and `rootCUnder` but **no `stemCUnder`** column, so the DTO hardcodes `stemCUnder = 0f`. Understory carbon is currently **leaf carbon only**. → question for David.

## 16. Riparian cube — stream + spatial structure / 河岸 cube

| Item | Result |
|---|---|
| Stream water level | Driven by `streamflow` (V3's `Qout` column is **entirely zero** — all outflow lives in `streamflow`, for both per-patch and aggregate rows) |
| Oak clustering | Oak forms groves hugging the stream on **both banks**; chaparral is pushed to the outer edges |
| Plants in the channel | `firLocations` and grass both exclude the `streamCenter ± streamWidth/2` band |

**Oak clustering method**: `firLocations` are sorted by an **anisotropic** distance to a set of clump centres — the cross-stream (X) term dominates and the along-stream (Z) term is weighted ×0.25. Plain Euclidean distance made the ordering Z-dominated, so chaparral collapsed into one quadrant instead of forming an outer band. Patch1 fills the array from the near end and patch2 from the far end (`fillFromFarEnd`), so the zoning survives death and regrowth.

## 17. Death: drought vs fire / 死亡：干旱与火

Two independent death paths, previously conflated:

**Drought** — was firing on ordinary carbon noise, with no awareness of fire. Now gated by:
```csharp
bool fireInvolved = terrainBurning || terrainBurnt;                      // post-fire recovery window too
bool bigEnoughDrop = (carbonAtMaturity - carbonInData) > carbonInData * droughtDeathThreshold;
```
Growing at `−halfStep` and culling at `+25%` also creates **hysteresis**, removing the grow/cull oscillation.

**Fire** — trees were never removed at all. `SetVegetationToDieFromFire` computed:
```csharp
firsToKill = (treeCarbonInViz - combinedCarbonOverInData) / treeAverageCarbonAmount;
//            ↑ all species, current       ↑ patch1's RAW carbon, not × percent
```
For the Riparian cube that is roughly `(1.0 − 3.7) / 0.2 = −13` → negative → `if (firsToKill > 0)` never fired → `SetTreesToBurn` **disabled** burning on every tree instead of igniting it. New `SetCentralCoastVegetationToDieFromFire` uses the same per-patch, percent-scaled, maturity-based basis as the growth loop. Also fixed an off-by-one (`i > 0`) that left one tree standing after a total burn — gated so BigCreek keeps its original quirk.

**Death visuals** — `FirController.UpdateDeath()` had an empty `// TO DO: FALL TO GROUND`. Implemented a topple animation (`enableFallAnimation`, off by default). Two subtleties: the tree's random spawn yaw must be preserved (multiply, don't overwrite, the rotation), and the rotation must be **reset before `TurnToLitter()`**, because `GetTreeActualHeight()` reads a **world-space AABB** — a trunk lying at 90° reports its width as its height and the litter log comes out the wrong size.

**Per-species dead models** — `deadTreePrefab` was a single cube-level field, so oak and chaparral left identical snags. Added `Species.deadPrefab` with fallback to the shared prefab (so BigCreek needs no configuration change).

## 18. Refactor + hardening / 重构与加固

`UpdateVegetation()` had grown to ~190 lines with **six** scattered `if (useCentralCoastPatches)` forks nested 4–5 deep. Collapsed to a single fork:

```
UpdateVegetation()
├── UpdateVegetationCentralCoast()   // ~20 lines
└── UpdateVegetationDefault()        // BigCreek, verbatim — zero CC conditionals inside
```

BigCreek's path is now a self-contained method that future Central Coast work cannot touch. Also removed dead code left over from an earlier iteration (`[VEGBAL]` logging and a patch-carbon merge that no longer had a consumer).

Null-guards added where missing (each of these was an actual crash this cycle):

| Location | Failure |
|---|---|
| `AddShrub` / `AddGrass` | `GetComponent<SERI_FireNodeChain>()` returned null → NRE on scene start |
| `TreeController.HideDeadTreeObjects` | `Find("LODGroup_DeadTree")` null; `curRootsObject` null |
| `TreeController.SetDeadPrefab` | same, crashing at the moment of death |
| `InstantiateTreeFromPrefab` | now fails loudly naming the species whose dead prefab is missing |
| `UpdateStream` | `MathUtil.MapValue` has no divide-by-zero guard → NaN water level |

## 19. Status / 现状

| Piece | Status | 中文 |
|-------|--------|------|
| Two-patch balance (growth + death, per species) | ✅ verified via `[PATCHBAL]` | 双 patch 平衡 |
| Oak riparian clustering / chaparral outer band | ✅ verified visually | 河岸格局 |
| `UpdateVegetation` single-fork refactor | ✅ done | 重构 |
| Plant-at-maturity accounting | 🔶 implemented, **needs verification** (watch `grown` → 0.9+) | 待验证 |
| Drought threshold + fire guard | 🔶 implemented, needs verification | 待验证 |
| Fire removes trees | 🔶 fixed, needs verification (watch `[CCFIRE]`) | 待验证 |
| Stream water level | 🔶 normalisation fixed + response curve added, needs verification | 待验证 |
| Grass as a carbon layer | 🔶 implemented, `[GRASS]` log not yet observed | 待验证 |
| Per-species dead prefabs | 🔶 implemented, needs prefab assignment in Inspector | 待配置 |
| Per-cube carbon calibration | ⬜ in progress — only saturated cubes need an override | 标定中 |
| Tree positions fixed for 32 years | ⬜ not started — slots are reused at identical coordinates | 未做 |
| Fire death visual (charred snag → fall → litter) | ⬜ not started | 未做 |
| Terrain material under the stream | ⬜ deferred — see below | 缓 |

### Calibration note / 标定说明
`TreeCarbonFactor = 0.027` was calibrated for BigCreek's firs. Central Coast carbon is on a different scale — the Riparian cube needed ~92 trees against a cap of 40. Added a per-cube `cubeTreeCarbonFactorOverride` (0 = use the shared value). **Rule: only a cube whose `alive` pins at `MaxTrees` needs an override; every other cube must stay at 0.** Raising it also widens the `halfStep` dead band, so applying it to an unsaturated cube empties it out.

### Isolation issue to fix / 隔离违规
The V3 Riparian cube's terrain currently uses **BigCreek's `C1_TerrainMaterial`** — a V3 cube pointing at a V2 asset. Must be duplicated into a Central Coast folder before any material edit. Separately, painting the terrain has no effect because NatureManufacture's "Terrain Snow Cover" shader blends four albedos through a manually assigned `_Splat_Map_1` texture and **never reads Unity's terrain control map**.

## 20. Open questions for David / 需要确认的问题

1. **Understory stem carbon** — the V3 RHESSys export has no `stemCUnder` column, so understory carbon is leaf-only. Can it be added to the export?
2. **A pre-existing dimensional bug in shared code** — `grassesToKill = (diff - shrubsToKill) / grassAverageCarbonAmount` divides a **rounding remainder** (dimensionless, ±0.5) by an **absolute carbon amount**, so the result is decided by rounding noise. Central Coast bypasses this path; **BigCreek's copy is untouched.** Fix it, or leave it?
3. **Per-cube carbon calibration** — is `cubeTreeCarbonFactorOverride` acceptable? Physically the carbon-per-metre of a species should be constant, but each display cube represents a different real patch area. There is precedent (`CubeATreeCarbonFactor` for the aggregate cube).
4. **`SetTreesToBurn`'s `i > 0` loop** — BigCreek always leaves one tree standing after a total burn. Intentional, or an off-by-one?

## 21. Next / 下一步

1. Finish per-cube carbon calibration; confirm `grown` climbs to ~0.9 (if not, `TreeGrowthSpeedFactor` may be too slow for the Central Coast time step — but it is shared with BigCreek).
2. Verify fire actually removes trees at the 11 known fire dates (`[CCFIRE]`).
3. Jitter tree slot coordinates on reuse, so regrowth does not reappear on the exact same 40 points for 32 years — while preserving the riparian zoning.
4. Fire death visual: charred snag → topple → litter, reusing the existing fall animation.
5. Duplicate the terrain material into a Central Coast folder and switch the shader so the streambed can actually be painted.

---

# Part 4 — `CubeController_CCV3`: how the Central Coast controller relates to the original `CubeController` (2026-07-27) / CC 控制器与原 CubeController 的关系

Up to Part 3 all the Central Coast logic lived **inside** the shared `CubeController.cs`, switched on by a public flag `useCentralCoastPatches`. My advisor asked that V3 have **its own code** that controls the two patches. This part restructures that logic into a dedicated subclass and explains exactly how the two classes relate.

## 22. Why a subclass, and not a separate class or a rewrite / 为什么用「继承」而不是独立类

`GameController` stores and drives **every** cube through the base type — `CubeController[] cubes`, `foreach (CubeController cube in cubes) cube.UpdateVegetationBehavior(...)`, `cube.UpdateFire(...)`, etc. So the Central Coast controller **must be a `CubeController`** to slot into those arrays and be driven by the existing game loop unchanged.

```csharp
public class CubeController_CCV3 : CubeController   // Assets/Scripts/Controllers/CubeController_CCV3.cs
```

- A **standalone** `MonoBehaviour` was rejected: it would not fit `CubeController[]`, forcing a fork of `GameController` too.
- A **rewrite/copy** of the 5,700-line controller was rejected: it would duplicate all the BigCreek behaviour and diverge over time.
- **Inheritance** lets the subclass reuse everything and override only the ~12 places where Central Coast differs. BigCreek cubes keep using `CubeController` directly and are never touched.

The pristine BigCreek baseline is kept at `D:\Git\CubeController.cs` (4,998 lines, zero Central Coast references) as the acceptance reference — see §26.

## 23. The seam pattern — dispatch by **type**, not by a flag / 接缝模式：按「类型」分派,而非标志位

Every Central Coast difference was converted from a `if (useCentralCoastPatches) … else …` fork into a **`protected virtual` seam** (a small hook method). The base class fills the seam with the BigCreek behaviour; `CubeController_CCV3` `override`s it with the Central Coast behaviour. The decision of "which behaviour runs" is now made by the **object's type** (via C# virtual dispatch), not by reading a flag.

```csharp
// Base (BigCreek) — CubeController.cs
protected virtual void UpdateVegetationCore() { UpdateVegetationDefault(); }   // single-patch balance

// Subclass (Central Coast) — CubeController_CCV3.cs
protected override void UpdateVegetationCore() { UpdateVegetationCentralCoast(); }   // per-patch balance
```

Consequence of moving from flag to type: a cube that must run Central Coast logic has to *be* a `CubeController_CCV3`, and a cube that must not (the aggregate) has to *be* a plain `CubeController`. This is why the aggregate cube was moved back to the base type — see §24.

## 24. Which cube uses which controller / 哪个 cube 用哪个控制器

The V3 scene has six cubes:

| Cube | Role / 角色 | Component | `patchID` |
|---|---|---|---|
| **A** | Aggregate summary / 汇总 | `CubeController` (base) | `-1` (the aggregate's real id in MySQL) |
| **B–F** | Five specific zones / 五个 zone | `CubeController_CCV3` (subclass) | 7-digit `ZZZZZPP` (zone + patch, e.g. `1326001`) |

**Rule of thumb / 判断准则:** a cube uses the subclass **only if it has two vegetation patches (patch1 / patch2)**. The aggregate has a single pre-summed dataset (no second patch), so it stays on the base controller. "Being V3 data" does **not** require the subclass — the base class loads and parses V3 API data perfectly well; the subclass adds only the *two-patch* behaviour.

## 25. Seams implemented (base virtual → subclass override) / 已实现的接缝

| # | Base virtual (BigCreek) | Subclass override (Central Coast) | What it controls |
|---|---|---|---|
| 1 | `UpdateVegetationCore()` | per-patch balance (`UpdateVegetationCentralCoast`) | overstory/grass balance each step |
| 2 | `ComputeStreamPos()` | raw streamflow / bankfull, with **flood** above `3E-4` | stream water level |
| 3 | `SetVegetationToDieFromFire()` | per-patch, percent-scaled fire death | which/how many trees die in a fire |
| 4 | `GetTreeCarbonFactor()` | adds `cubeTreeCarbonFactorOverride` for saturated cubes | carbon-per-tree |
| 5 | `LastBurnableTreeIndex()` (=1) | =0, so a full burn clears the whole cube | fire never spares a last tree |
| 6 | `OnFireExtinguished()` (no-op) | kills any still-burning tree at once (no trailing burn) | fire stop → trees die immediately |
| 7 | `GrowInitialGrassLayer()` | deterministic grass fill | initial understory |
| 8 | `RequestExtraPatchData()` + `ReadyToGrowFromData()` | loads member `patchID+1`, waits for both | patch2 data loading |
| 9 | `FillTreeSlotsFromFarEnd()` (=false) | patch2 (species > 0) fills from the far end | riparian slot ordering |
| 10 | `ClusterTreeLocations()` (no-op) | sorts locations into stream-hugging groves | riparian clustering |
| 11 | `GrowInitialOverstory()` | grows patch1 + patch2 each from its own carbon | initial overstory |

To let the subclass reach the state these seams need, a handful of base members were widened from `private` to `protected` (visibility only — no behaviour change): `firs`, `firLocations`, `timeIdx`, `StreamHeightMin/Max`, `p2Loaded`, `GetAliveTrees`, `NearestClumpDist`, `GrowPatchOverstory`, `GetOverstoryCarbonP2`, `FinishUpdateDataFromWebP2`, `GrowGrassPatches`.

**`useCentralCoastPatches` is now dormant:** after these seams the flag has **zero functional uses** anywhere in `Assets/Scripts` — only its field declaration remains. Dispatch is entirely type-based. The field is safe to delete as a final cleanup.

## 26. Isolation guarantee / 隔离保证

- **BigCreek behaviour is unchanged.** Every seam's base branch is the original BigCreek code; BigCreek cubes are base-type, so they always run it. Two earlier edits that had silently changed shared behaviour were undone into seams: `UpdateStream` (my old formula had replaced BigCreek's `log(qout)` mapping — now BigCreek's is restored and the V3 formula lives only in the override) and the vegetation/fire dispatches.
- **Acceptance test:** `diff` the live `CubeController.cs` against `D:\Git\CubeController.cs` should show only (a) `private → protected` visibility changes and (b) the documented `protected virtual` seam hooks. No BigCreek *logic* is altered.
- A few generic fixes do live in the **shared** tree/fire/litter code (dead-tree scale, litter null-guard, oversize-scale clamps, fire-extinguish hook). These are defensive and only trigger on the Central Coast paths, so BigCreek is unaffected in normal operation. They are in `TreeController`/`FirController`, **not** in `CubeController`, so they do not affect the `CubeController` acceptance test above.

## 27. What remains for the refactor / 重构还剩什么

1. **Delete** the dormant `useCentralCoastPatches` field (serialized bool on B–F; Unity drops the value silently).
2. **Physically relocate** the Central Coast method *bodies* still sitting in `CubeController.cs` (e.g. `UpdateVegetationCentralCoast`, `UpdatePatchOverstory`, `UpdateCentralCoastGrass`, `GetOverstoryCarbonP2`, `SetCentralCoastVegetationToDieFromFire`, `QueuePatchFireDeaths`, `GrowPatchOverstory`, per-species helpers) into `CubeController_CCV3.cs`, so the base *file* becomes pure BigCreek. The clustering body has already been moved as the first example.
3. Then implement the **symmetric patch redesign**: make patch1/patch2 fully equal — each with its own `memberID` (replacing the hardcoded `patchID+1`), species, area percent, and dead prefab — with cube hydrology as the area-weighted blend of the two members.

---
---

# Part 5 — Performance: scenario-switch load time (2026-10-28) / 性能:切换 scenario 的加载耗时
**Branch:** `staging-central-coast-data-api-updates-V3`

> Problem raised for the Unity sync: **switching the climate scenario (WRF / HadGEM / RSClim) is slow** — a visible stall before the new scenario renders. This part documents the exact load path, where the time goes, and the ranked options to fix it, so the discussion is grounded in code, not impressions.
> 中文:会议要提的问题——切 scenario 时有明显卡顿。这一部分把加载链路、耗时点、以及按性价比排的解决方案都对到代码,讨论时有据可依。

## 28. What one scenario switch actually does / 一次切换到底做了什么

```
OnScenarioChanged(index)                                   GameController.cs:477
  │  (CentralCoastV3 guard; sets warmingIdx = scenarioIdx)
  ├─ aggregate cube : SetWarmingIdx + UpdateDataFromWeb     GameController.cs:490-494
  ├─ 5 zone cubes   : SetWarmingIdx + UpdateDataFromWeb     GameController.cs:495-502
  │        each zone cube → UpdateDataFromWeb               CubeController.cs:2666
  │            ├─ RequestCubeData(patch1)                   CubeController.cs:2675
  │            └─ RequestExtraPatchData → RequestCubeData(patch2)   CubeController.cs:2677
  ├─ RebuildCentralCoastFiresWhenLoaded(index)              GameController.cs:507
  ├─ RefreshGraphWhenLoaded(graphedCube)                    GameController.cs:504
  └─ PreloadSideCubes()                                     GameController.cs:516

  per request:  WebManager.GetRequest → UnityWebRequest.Get (full download)   WebManager.cs:191
  per response: FinishUpdateDataFromWeb → parse ×2 + ranges + dict + regrow   CubeController.cs:2726
```

**Cost of one switch / 一次切换的成本:** up to **11 full-series HTTP requests** (1 aggregate + 5 zones × 2 patch members), each returning the entire **~15,340 daily rows × 41 columns** for that patch+scenario, each parsed and regrown **on the main thread**. Side-by-side mode adds the preload pass.
（最多 11 个全量请求,每个拉整条 ~15,340 天 × 41 列,全部在主线程解析 + 重长植被;side-by-side 再加一轮预载。）

## 29. Where the time goes / 耗时点(瓶颈 → 代码)

| # | Bottleneck | Code | Note / 中文 |
|---|-----------|------|------|
| **B1** | **No cache** — every switch re-downloads everything, even a scenario already viewed | `WebManager.RequestCubeData` :86 / `GetRequest` :191 | only fire frames are cached (`ccFireFramesByScenario`), not the cube data / 只缓存了火年帧,数据本身没缓存 |
| **B2** | Each request pulls the **whole time series** (no date-range trim) | API `cubedata/{patch}/{scenario}` | 43 years × daily × 41 cols → large payload |
| **B3** | **~11 requests** fired per switch | GameController.cs:495-502 + `RequestExtraPatchData` | aggregate 1 + 5 zones × 2 members |
| **B4** | Same JSON **parsed 2–3×** per member, each with a full string concat | `FinishUpdateDataFromWeb` :2728 **and** :2730 (P1 twice); P2 at :2756 | `"{\"rows\":" + json + "}"` allocates the whole payload again each parse |
| **B5** | After parsing, **2 more full passes** (min/max) + dict build + **vegetation regrow**, all **main-thread** | `FindParameterRanges` :4910, `LoadData` :2711, `GrowFromLoadedData` :1894 | this is the direct source of the frame stall / 卡帧直接来源 |

## 30. Options to fix, ranked by payoff / 解决方案(按性价比)

| Rank | Change | Scope | Touches BigCreek? API? |
|------|--------|-------|------------------------|
| **1** | **Cache loaded scenario data** in memory (key = `patchID + scenarioIdx`); a switch back to a seen scenario is instant, zero network | `UpdateDataFromWeb` / `FinishUpdateDataFromWeb` | Unity only; BigCreek untouched (guarded); no API change |
| **2** | **Collapse the duplicate parse** (B4): parse once, share the array between `dataRows` and `cubeData`; drop the string concat | `FinishUpdateDataFromWeb` | Unity only; zero-risk local change |
| **3** | **Silently preload all 3 scenarios** in the background after scene load | `GameController` + cube loader | Unity only |
| **4** | **Move parse + dict + range off the main thread** (`Task.Run`), return to main thread only for `GrowFromLoadedData` | `FinishUpdateDataFromWeb` | Unity only; removes the stall (B5) |
| **5** | **API side**: server-side cache per scenario / return only the columns Unity uses / enable gzip | Web API | API change — needs David |

> Recommendation for the meeting / 会议建议: **do #1 and #2 first** — both are Unity-only, don't touch BigCreek or the API, and together remove most of the felt latency (instant re-switch + half the parse cost). #3–#5 are follow-ups if more is needed.
> 中文:先做 1 和 2——纯 Unity 端、不动 BigCreek、不动 API,合起来就能把大部分卡顿消掉(重复切换秒开 + 解析减半)。3–5 作为后续。

## 31. Open questions for the Unity team / 需要和 Unity 团队确认

1. **Is a client-side scenario cache acceptable?** Data is static per scenario (never changes at runtime), so caching is safe — confirm there's no requirement to always re-fetch. / 客户端缓存 scenario 数据可以吗?数据运行期不变,缓存是安全的。
2. **Memory budget** — caching all 3 scenarios × 6 cubes holds ~33 full series in RAM. Acceptable on the target hardware? / 缓存三个 scenario 的内存占用能接受吗?
3. **API ownership** — if we want server-side caching / column trimming / gzip (option #5), who owns that change and on what timeline? / API 端优化谁来做、什么时间?
4. **Is the full 43-year series needed up front**, or could the API serve a window around the current year and stream the rest? / 一开始是否真需要整条 43 年,还是可以先给当前年附近的窗口、其余后台补?

---
---

# Part 6 — Unity for Humanity consulting session prep (2026-10-28) / Unity 顾问会准备
**Branch:** `staging-central-coast-data-api-updates-V3`

> This part turns the "Summary of Alpha Version" questions into a discussion plan for the **external Unity for Humanity consultants**. They do **not** know our codebase, so the goal is: give context fast, bring concrete numbers, and ask *"what would you do"* — not expect them to fix our code. It also answers **what to actually show them**.
> 中文:这一部分把 alpha 版问题整理成和 Unity 外部顾问讨论的计划。对方不了解我们的代码,所以重点是——快速给背景、带具体数字、问"你们会怎么做",而不是指望他们改代码;最后给出"到底该展示什么"。

## 32. How to run the session / 怎么开这个会

**Open with the hard constraints (the "must not break" list)** so every piece of advice is scoped to reality:
1. Inherited from **Big Creek**: **Built-in Render Pipeline + Unity 2022.3 LTS**.
2. **Must stay backward-compatible with Big Creek** — optimizations are either Central-Coast-only or safe for both.
3. **Two builds: Windows Desktop + WebGL**; Web should keep as much of Desktop's content/quality as possible.
4. **Fully data-driven** every step (vegetation amount/height, carbon, water, ET, photosynthesis, weather).
5. Local DB + REST API now, remote server later.

**Session mechanics / 会议机制:**
- **Send materials ahead**: this doc + a **2-min build demo video** + the key numbers, so they arrive prepared.
- **Every performance point carries a number** — without numbers they can only answer in generalities.
- Ask in two modes: **open** ("what's the best practice for X") and **decision** ("should we do X — yes/no").
- **Let them rank**: "given our constraints and small team, which 2–3 things would you do first by payoff?"
- **One note-taker**, record each item's **conclusion + owner + follow-up links**.
- **Order:** warm up on concrete Challenges a/b → then the strategic **render-pipeline decision** (it gates a lot) → finish with Gaussian Splatting (quick).

## 33. Topic-by-topic discussion plan / 逐条讨论计划

| # | Topic | How to frame it / 怎么框 | Specific asks / 具体问 | Want out of it / 想拿到 |
|---|-------|--------------------------|------------------------|--------------------------|
| **a** | **Init slow** (600+ instances) | ~600 vegetation GameObjects created at once (aggregate 200 + 5 zones × 80); each = species prefab + root prefab + ET particle system; recreated on scenario switch | Pooling? GPU instancing / `DrawMeshInstanced`? Async **spread-over-frames** instantiation? Addressables? Is per-instance particle system the cost — pool/GPU particles? ECS worth it under Built-in + BigCreek compat, or overkill? | A WebGL-friendly instance-management architecture that doesn't break BigCreek |
| **b** | **Vegetation rendering** (leaf cards / LOD / growth) | Oak canopy = leaf cards; LOD generator thinned the canopy on zoom-out; growth/death = whole-model uniform scaling | Keep canopy density while cutting overdraw/tris (impostors? atlasing? alpha-to-coverage? baked canopy mesh)? Is WebGL overdraw from transparent leaf cards the real killer? Is uniform scaling actually free of geometry cost (cost is draw calls/overdraw)? Cheaper, more natural growth via shader vertex displacement? | A "density-preserving + cheap" canopy approach + confirmation that scaling ≠ tri/vert conflict |
| **c** | **Environmental effects** (more coming) | Now: alpha-cutoff + color mapping (leaf carbon, soil moisture), particles (fire, ET). Planned: ground litter, fire splatmaps, rain/moisture/temp particles+shaders | How to add many data-driven effects on a budget (esp. Web)? Which are cheap vs expensive on WebGL (particles vs shader vs splatmap)? Use our central `EffectManager` for effect LOD / distance culling / toggles? Global shader params vs per-material? | A scalable effect-budget / management strategy, not single-effect recipes |
| **A-a** | **Render pipeline / version** ★ main one | Built-in RP + 2022.3; weighing **URP** and/or **Unity 6**, and **WebGPU** for Web quality | Under BigCreek compat, realistic **cost + risk** of URP migration? Can we run **CC on URP while BigCreek stays Built-in** — feasible? Does Unity 6 pay for itself here? Is **WebGPU in Unity 6 production-ready** for Web yet? | A **go/no-go** + if go, a **phased path** + BigCreek risk assessment |
| **A-b** | **3D Gaussian Splatting** | Idea: 3DGS for the **basin background** (and maybe aggregate cube); team has no experience | How hard to integrate 3DGS into a data-driven Built-in/URP + WebGL app? **Web-viable** (file size, decode cost)? Tooling maturity (e.g. Aras P.'s Unity GS package)? How does it coexist with dynamic foreground vegetation? | "Worth a prototype, or park it" decision |

## 34. What to show them — ranked / 该展示什么(按价值排序)

> For a **rendering + performance** consult, a **live profiling session beats source code**. Show in this order; code is tertiary and only to explain *architecture decisions* they'd advise on.
> 中文:渲染+性能咨询,**现场跑 Profiler 比看源码有用得多**。按下面顺序展示,代码排最后,只用来解释"我们为什么这么设计"。

**1. A running build + the profiler numbers (most important).** Open the **Stats** overlay, **Frame Debugger**, and **Profiler** on a live scene, and on the **WebGL build** if possible.
   - Show: **draw calls / batches / tris / verts**, frame time at scene-load vs runtime, where spikes land (instantiation vs rendering).
   - This is what lets a rendering expert diagnose. Capture these numbers *before* the meeting too, in case the demo machine struggles.

**2. One tree GameObject in the Inspector — the per-instance anatomy.** This makes challenges **a** and **b** concrete without any code.
   - The component tree: meshes + **LODGroup** / our **`DensityLODGroup`** (`Assets/Scripts/Controllers/DensityLODGroup.cs`), the **leaf-card canopy material + shader**, and the **ET particle system**.
   - Point out: ~600 of these exist at once, each carrying a particle system.

**3. A few code spots that embody the decisions (tertiary).** Only to answer "how do you currently do X":

| Question they'll ask | Show this | File : line |
|----------------------|-----------|-------------|
| How do you create/manage the instances? | `GrowFromLoadedData` (one-shot build) + `GrowAFir` (instantiate one tree) | `CubeController.cs:1894`, `:3152` |
| How do growth & death work? (the scaling concern) | `GrowTree` → `UpdateTreeLODsScale` (LOD child meshes scaled, not the parent) | `TreeController.cs:244`, `:677` |
| How do effects get driven by data? | `EffectManager` config + ET wind / emission | `Assets/Scripts/Controllers/EffectManager.cs` |
| Why is scenario switching slow? (ties to Part 5) | `OnScenarioChanged` + the duplicate parse in `FinishUpdateDataFromWeb` | `GameController.cs:477`, `CubeController.cs:2728`/`:2730` |

> **Do not** walk them through files top-to-bottom — they don't know the codebase and it burns the session. Lead with the **demo + profiler**, use the prefab to make cost tangible, and open a code file only when a specific question lands on one of the rows above.
> 中文:别逐行讲代码——对方不熟代码,会很浪费时间。先 demo+Profiler,再用 prefab 让"成本"看得见,只有当某个问题正好落到上表某一行时,才打开对应的代码文件。
