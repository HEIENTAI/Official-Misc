﻿/*************************************************************************************************************
------------------------------------------------------------------------------------------------
Flash to C#
<1101> 使用者選擇擁有 HappyGO 卡
<1102> 使用者選擇沒有 HappyGO 卡
<1201> 使用者選擇「Happy GO 卡申請」
<1202> 使用者選擇「領取」(兌換碼或點數券)
<1301> 使用者選擇「兌換」
<1302> 使用者選擇「領取」(兌換碼或點數券)(same as 1202)

<2101> 使用者選擇兌換「一項商品」(傳送商品編號)
<2301> 卡友對目前選擇商品，點擊「贈送」按鈕
<2302> 卡友對目前選擇商品，點擊「兌換」按鈕
<2303> 卡友對目前選擇商品，點擊「取消」按鈕

<3101> 點擊「確認」按鈕，使用者回傳完整手機號碼 (待確認此條是否需要)

<5101> 點擊「確認」按鈕，使用者回傳完整兌換碼 (待確認此條是否需要)

<6101> 點擊「確認」按鈕，使用者回傳完整點數券碼 (待確認此條是否需要, and 是否有英文字母)
------------------------------------------------------------------------------------------------
C# to Flash

<0100> 要求螢幕進入「待機頁面」(主畫面)

<1100> 進入激活流程 - 要求螢幕顯示「是否擁有 Happy GO 卡」
<1200> 要求螢幕顯示 「Happy GO 卡申請」、「領取」選項
<1300> 要求螢幕顯示 「兌換」、「領取」選項
<1400> 要求螢幕顯示 - 提示「請在感應區刷Happy購卡或掃描動態消費碼」
<1500> 要求螢幕顯示 - 提示「您可使用的開心點數：xx。請選擇您要兌換的樣品」
<1800> 要求螢幕顯示 「卡片未激活，暫不能使用，請洽客服」
<1900> 要求螢幕顯示 「動態消費碼已失效，請檢查動態消費碼是否超時或輸入錯誤，如有疑問，請洽客服4000218826」

<2100> 進入商品點數兌換流程 - 要求螢幕顯示 「可兌換商品」   (通常是1500後接著送)
<2200> 要求螢幕顯示 「您不符合該樣品的兌換資格」
<2300> 要求螢幕進入 「進入樣品介紹頁面」，並依據後台返回結果顯示兌換所需點數。並顯示「兌換」「贈送」「取消」 按鈕
<2400> 要求螢幕顯示 「兌換成功，請取走您兌換的樣品」，提示「繼續兌換其他樣品」
<2500> 要求螢幕顯示 「出貨失敗，如有疑問，請洽客服4000218826」

<3100> 進入商品樣品轉贈流程 - 提示「請輸入您好友的手機號碼」
<3200> 手機格式輸入錯誤 - 要求螢幕顯示 「您輸入的手機號碼格式不正確請重新輸入」
<3300> 手機格式輸入正確 - 要求螢幕顯示 「已經贈送成功，您的好友可以憑他手機上收到的兌換碼到HAPPY TRY上領取您送給他的禮物，謝謝使用！」，提示「繼續兌換其他樣品」

<5100> 進入兌換碼領取流程 - 要求螢幕顯示 「輸入兌換碼」
<5200> 要求螢幕顯示 - 提示「你輸入的兌換碼不正確或已失效，請確認後重新輸入或洽客服4000218826」
<5300> 要求螢幕顯示 - 提示「您好友推薦的樣品是XX」，同時顯示該樣品庫存狀態「有貨/缺貨」 (該指令後接 2400,2500相同流程)

<6100> 進入點數券領取流程 - 要求螢幕顯示 「輸入點數券」
<6200> 要求螢幕顯示 - 提示「你輸入的點數券不正確或已失效，請確認後重新輸入或洽客服4000218826」
<6300> 要求螢幕顯示 - 提示「您可使用的開心點數：xx。請選擇您要兌換的樣品，點數券餘額不退還」
<6400> 要求螢幕進入 「進入樣品介紹頁面」，並依據後台返回結果顯示兌換所需點數。並顯示「兌換」「取消」 按鈕 (不同於2300, 不顯示「贈送」) (該指令後接 2400,2500相同流程)

<8100> 通知輸入框，使用者輸入一個數字 (0~9)   (待確認數字輸入方式)
<8200> 通知輸入框，使用者鍵入回車鍵

<9100> 進入申請HG卡流程 - 要求螢幕顯示 「輸入申請編碼」(Happy GO 編碼)
*****************************************************************************************************************/