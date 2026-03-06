#!/usr/bin/env fish
# Usage:
#   ./images_to_md.fish /path/to/folder > book.md
#   ./images_to_md.fish /path/to/folder book.md

function usage
    echo "Usage: "(status filename)" <image_folder> [output_md]"
    echo "Example: "(status filename)" ./MyBook > MyBook.md"
end

if test (count $argv) -lt 1
    usage
    exit 1
end

set -l folder $argv[1]

if not test -d "$folder"
    echo "Error: not a folder: $folder" >&2
    exit 1
end

# 文件夹名（不含路径）
set -l folder_name (basename "$folder")

# 输出目标：stdout 或文件
set -l out /dev/stdout
if test (count $argv) -ge 2
    set out $argv[2]
end

# 支持的图片扩展（按需增减）
set -l exts webp jpg jpeg png gif avif tif tiff bmp

# 生成排序后的文件列表（字典序即可保证 00001, 00002 ...）
set -l files
for ext in $exts
    for f in "$folder"/*.$ext
        if test -f "$f"
            set -a files "$f"
        end
    end
end

if test (count $files) -eq 0
    echo "Error: no image files found in $folder" >&2
    exit 1
end

# 排序（避免 glob 顺序差异）
set -l sorted (printf "%s\n" $files | sort)

# 写入 markdown
begin
    echo "# $folder_name"
    echo

    for f in $sorted
        set -l base (basename "$f") # 00001.webp
        set -l stem (path change-extension "" "$base") # 00001

        # 去掉前导 0，且确保全 0 的情况变成 0
        set -l page (string replace -r '^0+' '' "$stem")
        if test -z "$page"
            set page 0
        end

        echo "![](./$folder_name/$base)"
        echo
    end
end | pandoc -f markdown -o "$folder_name.epub" --epub-cover-image="$folder/00001.webp"
