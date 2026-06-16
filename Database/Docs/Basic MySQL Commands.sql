SELECT * FROM futuremtn_central_coast.cubedata;

USE futuremtn_central_coast;

SELECT 'dates' AS table_name, COUNT(*) AS rows_found FROM dates
UNION ALL SELECT 'cubedata', COUNT(*) FROM cubedata
UNION ALL SELECT 'waterdata', COUNT(*) FROM waterdata
UNION ALL SELECT 'firedata', COUNT(*) FROM firedata
UNION ALL SELECT 'patchdata', COUNT(*) FROM patchdata
UNION ALL SELECT 'stratumdata', COUNT(*) FROM stratumdata
UNION ALL SELECT 'terraindata', COUNT(*) FROM terraindata;


SHOW CREATE TABLE cubedata;
SHOW CREATE TABLE firedata;
SHOW CREATE TABLE patchdata;


USE futuremtn_central_coast;
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE cubedata;
TRUNCATE TABLE patchdata;
TRUNCATE TABLE firedata;
SET FOREIGN_KEY_CHECKS = 1;

ALTER TABLE cubedata AUTO_INCREMENT = 1;
ALTER TABLE firedata AUTO_INCREMENT = 1;
ALTER TABLE patchdata AUTO_INCREMENT = 1;


USE futuremtn_central_coast;
CREATE TABLE `firedata` (
  `id` int NOT NULL AUTO_INCREMENT,
  `importRunId` int NOT NULL,
  `scenarioRunId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `warmingIdx` int NOT NULL,
  `sourceFile` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `year` int NOT NULL,
  `month` int NOT NULL,
  `level` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `basinID` int NOT NULL,
  `hillID` int DEFAULT NULL,
  `zoneID` int DEFAULT NULL,
  `patchID` bigint DEFAULT NULL,
  `burn` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IX_FireData_scenarioRunId_warmingIdx_year_month_zoneID_patchID` (`scenarioRunId`,`warmingIdx`,`year`,`month`,`zoneID`,`patchID`)
) ENGINE=InnoDB AUTO_INCREMENT=1006877441 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
