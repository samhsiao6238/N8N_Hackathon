#!/bin/bash

# 取得目前編輯中的檔案路徑（VSCode 可用 $1 傳入）
file="$1"

# 使用 awk 處理，避免誤刪 code block 中的內容
awk '
BEGIN {
    in_code = 0;
}
{
    # 偵測是否進入或離開 code block
    if ($0 ~ /^```/) {
        in_code = !in_code;
    }

    if (!in_code) {
        # 刪除獨立一行的 ---
        if ($0 ~ /^---$/) {
        next;
        }

        # 移除行內出現的 （粗體符號），但不處理 code block
        gsub(/\*\*/, "", $0);
    }

    print;
}
' "$file" > "$file.cleaned"

# 將處理後的內容覆蓋原始檔案
mv "$file.cleaned" "$file"
