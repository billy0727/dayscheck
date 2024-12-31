# TR Test

## 概述

這個 Shell 腳本旨在分析無線網路資料，主要功能包括統計資料筆數、檢測斷線次數、計算訊號強度的平均值及標準差。腳本使用兩個檔案：`macs.txt` 和 `macs_capital.txt`。

- `macs.txt`：包含原始格式的 MAC 位址，這是需要監控的 MAC 地址。
- `macs_capital.txt`：包含轉換為大寫並移除冒號的 MAC 位址，這是腳本所需的格式。

# 檔案結構

此腳本假設以下檔案結構：

- `/dayscheck`
  - `caldata.sh` - 計算資料數量
  - `calrss.sh` - 計算訊號強度
  - `cal206.sh` - 計算斷線次數
  - `macs.txt` - 原始格式的 MAC 位址
  - `macs_capital.txt` - 大寫格式且無冒號的 MAC 位址

## 設定步驟

1. **準備 MAC 位址檔案**：

   - 編輯 `macs.txt`，將您需要監控的 MAC 位址按照原始格式（例如 `00:1A:2B:3C:4D:5E`）填入。
   - 編輯 `macs_capital.txt`，將相同的 MAC 位址轉換為大寫並移除冒號（例如 `001A2B3C4D5E`）。

2. **給予執行權限**：
   在您的終端機執行以下指令，將腳本檔案設為可執行：

   ```bash
   chmod +x caldata.sh calrss.sh
   ```

## 使用方法

1. **編輯 MAC 位址檔案**：

打開並編輯 macs.txt，將您要監控的 MAC 位址按照原始格式填入。
在 macs_capital.txt 中，將這些位址轉換為大寫並移除冒號，然後儲存。

2. **執行 Shell 腳本： 在終端機中執行以下命令來啟動腳本**：

   ```bash
   sudo bash ./caldata.sh 2024-12-31
   sudo bash ./cal206.sh 2024-12-31
   sudo bash ./calrssi.sh 2024-12-31
   日期依需求修改
   ```

3. **查看輸出結果： 腳本會處理資料並輸出**：
   - 偵測到的資料筆數。
   - 偵測到的斷線次數。
   - 訊號強度的平均值和標準差。
     您可以在終端機中查看這些結果，或將其輸出至檔案以供後續分析。
