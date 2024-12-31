#! /bin/bash
# count_v5.sh
# Billy Hsia
# function: 根據指定的日期統計關鍵字的資料筆數，並用表格列出。
# create date: 2024
# date:
#   2024/03/07 new
#   2024/12/30 updated

# 設置關鍵字
keywords=("status:206")

# 確認是否輸入日期參數
if [ -z "$1" ]; then
    echo "請提供要計算的日期 (格式: YYYY-MM-DD)。例如: sudo bash $0 2024-11-24"
    exit 1
fi

# 取得輸入的日期
input_date="$1"

# 檢查日期格式是否正確
if ! date -d "$input_date" >/dev/null 2>&1; then
    echo "日期格式錯誤，請使用 YYYY-MM-DD 格式。"
    exit 1
fi

# 設定起始和結束時間
start_timestamp="$input_date 00:00"
end_timestamp="$input_date 23:59"

# 打印表頭
echo -ne "關鍵詞/MAC\t"
for keyword in "${keywords[@]}"; do
    echo -ne "\t$keyword"

done
echo

# 從 macs_capital.txt 讀取 MAC 地址
if [ ! -f macs_capital.txt ]; then
    echo "找不到 macs_capital.txt 文件，請確保該文件存在於當前目錄。"
    exit 1
fi

while read -r mac; do
    # 打印 MAC 地址
    echo -ne "$mac"
    for keyword in "${keywords[@]}"; do
        # 計算關鍵字的出現次數
        count=$(grep -a "$mac" /var/log/bed_raw_data_rec.log |
                awk -v start="$start_timestamp" -v end="$end_timestamp" '{timestamp = substr($0, 1, 16)} timestamp >= start && timestamp <= end' |
                grep -a "$keyword" |
                wc -l)
        echo -ne "\t$count"
    done
    echo
done < macs_capital.txt

