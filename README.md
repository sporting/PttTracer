# Trace ptt user's status with shell script

## How to install

0. 下載所有檔案到 home 目錄下的 expectptt

1. 請先建立以下目錄結構
 - `./expectptt/bin`  -->  bash 執行目錄，請將所有下載檔案放在這裡
 - `./expectptt/log`  -->  執行 ptt.sh 產生的暫存檔案
 - `./expectptt/log/daily`  -->  analptt.sh 整理過後的log file
 - `./expectptt/log/backfile`  -->  備份 ptt.sh 產生的暫存檔案

2. 修改 ptt.sh 變數
 - `[OWNER_NAME]` = linux 帳號
 - `[PTT_ACCOUNT]` = ptt 帳號
 - `[PTT_PASSWORD]` = ptt 密碼
 - `[PTT_QUERY_ACCOUNT]` = 欲查詢的 ptt 帳號

3. 檔案說明
 - `ptt.sh` 主要程序
 - `pttLoopQuery` 使用 `expect` 查詢 ptt 網友動態
 - `pttLoopQuery_big5` 透過 `ptt.sh` 自動將 `pttLoopQuery`(utf-8) 轉換成 big5 的格式
 - `analptt.sh` 將重複的動態去除，以便於分析

4. 使用方法ss
 將 `ptt.sh` 設上排程，每分鐘執行，`ptt.sh` 會判斷執行中則結束程序，不須擔心資源耗盡
 檢視 `./expectptt/log/daily` 的結果即可
