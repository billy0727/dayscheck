#!/bin/bash

# 確保提供了正確數量的參數
if [ "$#" -ne 1 ]; then
    echo "使用方法: $0 <日期>"
    echo "日期格式: YYYY-MM-DD"
    exit 1
fi

TARGET_DATE="$1"
FILE_PATH="/var/log/rssi_rec.log"
#FILE_PATH="$2"

# 使用awk處理文本，對每個MAC ID計算平均值和標準差
awk -v target_date="$TARGET_DATE" '
{
    # 從每一行中提取日期、MAC ID和rssi值
    match($0, /^([0-9-]+) [0-9:]+.*mac:([0-9A-F]{12}) rssi:(-?[0-9]+)/, arr)
    if (arr[1] == target_date && arr[2] != "" && arr[3] != "") {
        mac = arr[2]
        rssi = arr[3]
        # 將RSSI值轉換為絕對值
        rssi = sqrt(rssi^2)
        sum[mac] += rssi
        sumsq[mac] += rssi^2
        count[mac]++
    }
}
END {
    printf "%-15s %-10s %-10s\n", "MAC ID", "平均RSSI", "標準差"
    for (mac in sum) {
        if (count[mac] > 1) {
            mean = sum[mac] / count[mac]
            variance = (sumsq[mac] - (sum[mac]^2 / count[mac])) / (count[mac] - 1)
            stddev = sqrt(variance)
            printf "%-15s %-10.2f %-10.2f\n", mac, mean, stddev
        }
    }
}' $FILE_PATH
