#! /bin/bash
# count_v5.sh
# Billy Hsia
# fuction: 輸入起始時間及結束時間, 可統計keywords裡的資料筆數, 並用表格列出。
# create date: 2024
# date:
  # 2024/03/07 new

#!/bin/bash
# 设置关键词
keywords=("pz" "fs" "bs" "bs_min" "switch_level")

# 提示用户输入起始和结束日期时间
read -p "请输入起始日期和时间 (格式: MM-DD HH:MM): " start_input
read -p "请输入结束日期和时间 (格式: MM-DD HH:MM): " end_input

# 组合日期时间字符串，年份固定为2024
start_datetime="2024-$start_input"
end_datetime="2024-$end_input"

# 将日期时间转换为用于比较的格式
start_timestamp=$(date -d "$start_datetime" +"%Y-%m-%d %H:%M")
end_timestamp=$(date -d "$end_datetime" +"%Y-%m-%d %H:%M")

# 打印表头
echo -ne "关键词/MAC\t"
for keyword in "${keywords[@]}"; do
    echo -ne "\t$keyword"
done
echo

while read -r mac; do
    # 打印 MAC 地址
    echo -ne "$mac"
    for keyword in "${keywords[@]}"; do
        # 对每个关键词在指定时间范围内计数并打印
        count=$(grep -a "$mac" /var/log/bed_raw_data_rec.log | awk -v start="$start_timestamp" -v end="$end_timestamp" '{timestamp = substr($0, 1, 16)} timestamp >= start && timestamp <= end' | grep -a "$keyword" | wc -l)
        echo -ne "\t$count"
    done
    echo
done < mac.txt
