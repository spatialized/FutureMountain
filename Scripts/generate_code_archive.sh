#!/usr/bin/env bash

# Future Mountain Full Text Archive Generator
# Generates a full text archive of source-oriented files for the Unity project
# and embedded RHESSys Data Importer.
#
# Usage:
#   macOS/Linux/Git Bash:
#     ./Scripts/generate_code_archive.sh
#     ./Scripts/generate_code_archive.sh --dry-run
#
#   Windows cmd.exe:
#     Scripts\generate_code_archive.cmd
#     Scripts\generate_code_archive.cmd --dry-run
#
#   Windows PowerShell:
#     .\Scripts\generate_code_archive.cmd
#     .\Scripts\generate_code_archive.cmd --dry-run
#
# Run from the project root.
# Output:
#   FutureMountain_Full_Text_Archive.md
#   FutureMountain_Full_Text_Archive.pdf when pandoc + a PDF engine are available
#   FutureMountain_Full_Text_Archive.html when PDF engines are unavailable

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ARCHIVE_BASENAME="FutureMountain_Full_Text_Archive"
MARKDOWN_FILE="$PROJECT_ROOT/${ARCHIVE_BASENAME}.md"
PDF_FILE="$PROJECT_ROOT/${ARCHIVE_BASENAME}.pdf"
HTML_FILE="$PROJECT_ROOT/${ARCHIVE_BASENAME}.html"

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
elif [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    sed -n '1,16p' "$0"
    exit 0
elif [[ -n "${1:-}" ]]; then
    echo "[ERROR] Unknown argument: $1" >&2
    echo "Usage: ./Scripts/generate_code_archive.sh [--dry-run]" >&2
    exit 1
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

TEMP_FILE_LIST="$(mktemp)"
cleanup() {
    rm -f "$TEMP_FILE_LIST" "$TEMP_FILE_LIST.sorted" "$TEMP_FILE_LIST.raw"
}
trap cleanup EXIT

cd "$PROJECT_ROOT"

if [[ "$DRY_RUN" == "true" ]]; then
    log_info "Running in dry-run mode; no archive files will be generated."
fi

log_info "Project root: $PROJECT_ROOT"

is_excluded_path() {
    local path="$1"

    case "$path" in
        .git/*|.vs/*|Library/*|Temp/*|obj/*|Obj/*|Logs/*|UserSettings/*|MemoryCaptures/*|Build/*|Builds/*)
            return 0
            ;;
        FutureMountain_Full_Text_Archive.md|FutureMountain_Full_Text_Archive.pdf|FutureMountain_Full_Text_Archive.html)
            return 0
            ;;
        RHESSYs_Data_Importer/Data/*|RHESSYs_Data_Importer/RHESSYs_Data_Importer/data/*)
            return 0
            ;;
        RHESSYs_Data_Importer/**/bin/*|RHESSYs_Data_Importer/**/Bin/*|RHESSYs_Data_Importer/**/obj/*|RHESSYs_Data_Importer/**/Obj/*)
            return 0
            ;;
        Assets/AssetStoreTools*|Assets/Resources/SERI_Data*|Assets/Resources/SplatData*)
            return 0
            ;;
        *.png|*.jpg|*.jpeg|*.gif|*.bmp|*.tif|*.tiff|*.ico|*.psd|*.tga|*.exr|*.hdr)
            return 0
            ;;
        *.dll|*.exe|*.pdb|*.mdb|*.so|*.dylib|*.a|*.lib)
            return 0
            ;;
        *.mp3|*.wav|*.ogg|*.mp4|*.mov|*.avi|*.webm)
            return 0
            ;;
        *.fbx|*.blend|*.dae|*.obj|*.assetbundle|*.unitypackage|*.apk|*.aab)
            return 0
            ;;
        *.csv|*.tsv|*.sqlite|*.db)
            return 0
            ;;
        *.meta|*.unity|*.prefab|*.asset|*.mat|*.controller|*.anim|*.overridecontroller|*.playable|*.mask|*.preset|*.terrainlayer)
            return 0
            ;;
    esac

    return 1
}

is_included_text_file() {
    local path="$1"
    local name="${path##*/}"
    local lower="${path,,}"

    case "$name" in
        .gitignore|.gitattributes|.collabignore|.vsconfig|README|LICENSE|NOTICE)
            return 0
            ;;
    esac

    case "$lower" in
        *.cs|*.shader|*.cginc|*.compute|*.hlsl|*.glsl|*.asmdef|*.asmref)
            return 0
            ;;
        *.sln|*.csproj|*.props|*.targets|*.config|*.resx|*.ruleset)
            return 0
            ;;
        *.json|*.xml|*.yaml|*.yml|*.toml|*.ini|*.conf|*.settings)
            return 0
            ;;
        *.md|*.markdown|*.txt|*.rst)
            return 0
            ;;
        *.sh|*.bash|*.ps1|*.bat|*.cmd)
            return 0
            ;;
        *.uxml|*.uss|*.html|*.css|*.js|*.ts)
            return 0
            ;;
    esac

    return 1
}

detect_language() {
    local path="$1"
    local lower="${path,,}"

    case "$lower" in
        *.cs) echo "csharp" ;;
        *.json) echo "json" ;;
        *.xml|*.csproj|*.props|*.targets|*.resx|*.uxml) echo "xml" ;;
        *.yaml|*.yml) echo "yaml" ;;
        *.shader|*.cginc|*.compute|*.hlsl|*.glsl) echo "hlsl" ;;
        *.sh|*.bash) echo "bash" ;;
        *.ps1) echo "powershell" ;;
        *.bat|*.cmd) echo "batch" ;;
        *.html) echo "html" ;;
        *.css|*.uss) echo "css" ;;
        *.js) echo "javascript" ;;
        *.ts) echo "typescript" ;;
        *.md|*.markdown) echo "markdown" ;;
        *) echo "text" ;;
    esac
}

file_size_bytes() {
    local path="$1"
    wc -c < "$path" 2>/dev/null | tr -d '[:space:]'
}

write_html_fallback_from_markdown() {
    local markdown_path="$1"
    local html_path="$2"

    {
        cat << EOF
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Future Mountain Full Text Archive</title>
<style>
body {
  margin: 2rem;
  font-family: Consolas, "Courier New", monospace;
  font-size: 12px;
  line-height: 1.35;
  color: #111;
  background: #fff;
}
pre {
  white-space: pre-wrap;
  word-break: break-word;
}
@media print {
  body { margin: 0.5in; }
}
</style>
</head>
<body>
<pre>
EOF
        awk '{ gsub(/&/, "\\&amp;"); gsub(/</, "\\&lt;"); gsub(/>/, "\\&gt;"); print }' "$markdown_path"
        cat << EOF
</pre>
</body>
</html>
EOF
    } > "$html_path"
}

write_fenced_file_contents() {
    local full_path="$1"
    local language="$2"

    local max_backticks
    max_backticks="$(awk '
        {
            line = $0
            while (match(line, /`+/)) {
                if (RLENGTH > m) m = RLENGTH
                line = substr(line, RSTART + RLENGTH)
            }
        }
        END { print m + 0 }
    ' "$full_path")"

    local fence_len=$((max_backticks + 1))
    if (( fence_len < 3 )); then
        fence_len=3
    fi

    local fence
    fence="$(printf '%*s' "$fence_len" '' | tr ' ' '`')"

    {
        echo "${fence}${language}"
        cat "$full_path"
        echo
        echo "$fence"
    } >> "$MARKDOWN_FILE"
}

should_add_page_break() {
    local current_file="${1:-}"
    local previous_file="${2:-}"

    [[ -n "$previous_file" ]] || return 1

    local current_folder="${current_file%%/*}"
    local previous_folder="${previous_file%%/*}"

    [[ "$current_folder" != "$previous_folder" ]]
}

log_info "Collecting text files..."

if command -v git >/dev/null 2>&1 && git rev-parse --show-toplevel >/dev/null 2>&1; then
    git ls-files --cached --others --exclude-standard > "$TEMP_FILE_LIST.raw"
else
    find . -type f -print | sed 's|^\./||' > "$TEMP_FILE_LIST.raw"
fi

# Unity's root solution/project files are generated and commonly ignored, but
# include them when present because they are useful in a complete text archive.
find . -maxdepth 1 -type f \( -name "*.sln" -o -name "*.csproj" \) -print \
    | sed 's|^\./||' >> "$TEMP_FILE_LIST.raw"

while IFS= read -r file_path; do
    if is_excluded_path "$file_path"; then
        continue
    fi

    if is_included_text_file "$file_path"; then
        printf '%s\n' "$file_path" >> "$TEMP_FILE_LIST"
    fi
done < "$TEMP_FILE_LIST.raw"

sort -f "$TEMP_FILE_LIST" > "$TEMP_FILE_LIST.sorted"
mv "$TEMP_FILE_LIST.sorted" "$TEMP_FILE_LIST"

sort -fu "$TEMP_FILE_LIST" > "$TEMP_FILE_LIST.sorted"
mv "$TEMP_FILE_LIST.sorted" "$TEMP_FILE_LIST"

file_count="$(wc -l < "$TEMP_FILE_LIST" | tr -d '[:space:]')"
if [[ "$file_count" -eq 0 ]]; then
    log_error "No text files found."
    exit 1
fi

if [[ "$DRY_RUN" == "true" ]]; then
    log_success "Found $file_count files."
    echo
    echo "=== DRY RUN: Files that would be included ==="
    cat "$TEMP_FILE_LIST"
    echo
    echo "=== DRY RUN SUMMARY ==="
    echo "Files: $file_count"
    echo "Markdown output: $MARKDOWN_FILE"
    echo "PDF output:      $PDF_FILE"
    echo "HTML fallback:   $HTML_FILE"
    exit 0
fi

total_lines=0
total_bytes=0
while IFS= read -r file_path; do
    lines="$(wc -l < "$file_path" 2>/dev/null || echo 0)"
    bytes="$(file_size_bytes "$file_path")"
    total_lines=$((total_lines + lines))
    total_bytes=$((total_bytes + bytes))
done < "$TEMP_FILE_LIST"

log_success "Found $file_count files, $total_lines lines, $total_bytes bytes."

rm -f "$MARKDOWN_FILE" "$PDF_FILE" "$HTML_FILE"

current_date="$(date +"%Y-%m-%d %H:%M:%S %Z")"
git_ref="$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")"
git_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")"

cat > "$MARKDOWN_FILE" << EOF
# Future Mountain Full Text Archive

**Generated:** $current_date  
**Git branch:** $git_branch  
**Git commit:** $git_ref  
**Total files:** $file_count  
**Total lines:** $total_lines  
**Total bytes:** $total_bytes  

This archive includes source-oriented text files from Future Mountain and the
embedded RHESSys Data Importer. Generated Unity folders, build outputs, raw
RHESSys data bundles, binary assets, and prior archive outputs are excluded.

---

EOF

previous_file=""
file_number=0

while IFS= read -r file_path; do
    file_number=$((file_number + 1))
    language="$(detect_language "$file_path")"
    size="$(file_size_bytes "$file_path")"

    if should_add_page_break "$file_path" "$previous_file"; then
        printf '\n\\pagebreak\n\n' >> "$MARKDOWN_FILE"
    fi

    cat >> "$MARKDOWN_FILE" << EOF

# $file_path

**File type:** $language  
**Size:** $size bytes  

EOF

    if [[ -s "$file_path" ]]; then
        write_fenced_file_contents "$file_path" "$language"
    else
        {
            echo "\`\`\`${language}"
            echo "// Empty file"
            echo "\`\`\`"
        } >> "$MARKDOWN_FILE"
    fi

    previous_file="$file_path"

    if (( file_number % 100 == 0 )); then
        log_info "Processed $file_number/$file_count files..."
    fi
done < "$TEMP_FILE_LIST"

log_success "Markdown archive generated: $MARKDOWN_FILE"

if ! command -v pandoc >/dev/null 2>&1; then
    log_warning "pandoc is not available; generating simple HTML fallback."
    write_html_fallback_from_markdown "$MARKDOWN_FILE" "$HTML_FILE"
    log_success "HTML fallback generated: $HTML_FILE"
    echo
    echo "=== Future Mountain Full Text Archive Complete ==="
    echo "Markdown: $MARKDOWN_FILE"
    echo "HTML:     $HTML_FILE"
    echo "Files:    $file_count"
    echo "Lines:    $total_lines"
    exit 0
fi

PDF_ENGINES=("xelatex" "pdflatex" "wkhtmltopdf" "weasyprint" "prince" "context")
conversion_success=false

for engine in "${PDF_ENGINES[@]}"; do
    if command -v "$engine" >/dev/null 2>&1; then
        log_info "Trying PDF engine: $engine"
        if pandoc "$MARKDOWN_FILE" \
            --toc \
            --number-sections \
            -V geometry:margin=0.75in \
            -V fontsize=8pt \
            --pdf-engine="$engine" \
            -o "$PDF_FILE" >/dev/null 2>&1; then
            conversion_success=true
            log_success "PDF archive generated: $PDF_FILE"
            break
        fi

        log_warning "PDF engine failed: $engine"
    fi
done

if [[ "$conversion_success" == "false" ]]; then
    log_warning "No PDF engine succeeded; generating HTML fallback."
    if pandoc "$MARKDOWN_FILE" \
        --toc \
        --number-sections \
        --standalone \
        -o "$HTML_FILE"; then
        conversion_success=true
        log_success "HTML fallback generated: $HTML_FILE"
    else
        log_error "HTML fallback generation failed."
        exit 1
    fi
fi

echo
echo "=== Future Mountain Full Text Archive Complete ==="
echo "Markdown: $MARKDOWN_FILE"
if [[ -f "$PDF_FILE" ]]; then
    echo "PDF:      $PDF_FILE"
elif [[ -f "$HTML_FILE" ]]; then
    echo "HTML:     $HTML_FILE"
fi
echo "Files:    $file_count"
echo "Lines:    $total_lines"
