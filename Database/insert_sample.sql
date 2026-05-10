/* =========================================================
   日記管理系統 - 假資料
   ========================================================= */

USE [DiarySystemDB];
GO

/* =========================================================
   先清空現有測試資料再執行以下
   ========================================================= */
DELETE FROM dbo.DiaryReaction;      
DELETE FROM dbo.DiaryMoodSelection; 
DELETE FROM dbo.DiaryTag;         
DELETE FROM dbo.DiaryMedia;        
DELETE FROM dbo.DiaryMood;          
DELETE FROM dbo.DiaryNormal;       
DELETE FROM dbo.Diary;             
DELETE FROM dbo.Mood;              
DELETE FROM dbo.Tag WHERE TagType = 'custom';  
DELETE FROM dbo.[User];                      
GO

/* 重置 IDENTITY 計數器 */
DBCC CHECKIDENT ('dbo.[User]', RESEED, 0);
DBCC CHECKIDENT ('dbo.Diary',  RESEED, 0);
GO

/* =========================================================
   插入2位使用者
   修正：補齊所有 NOT NULL 欄位（Password, Phone, Nickname, birthday, CreatedAt）
   ========================================================= */
SET IDENTITY_INSERT dbo.[User] ON;
INSERT INTO dbo.[User]
    (UserId, Email,                         Password,          Phone,          Nickname,   birthday,     CreatedAt)
VALUES
    (1,      N'siqi.li@example.com',        N'hashed_pw_001',  N'0912345678',  N'霧中旅人',  N'1995-03-20', '2025-01-01 00:00:00'),
    (2,      N'xiangyu.zhang@example.com',  N'hashed_pw_002',  N'0923456789',  N'夜行貓咪',  N'1993-07-15', '2025-01-01 00:00:00');
SET IDENTITY_INSERT dbo.[User] OFF;
GO

/* =========================================================
   插入系統標籤
   ========================================================= */
IF NOT EXISTS (SELECT 1 FROM dbo.Tag WHERE TagId = 'work')
BEGIN
    INSERT INTO dbo.Tag (TagId, UserId, TagName, TagType)
    VALUES
        ('work',         NULL, N'工作', 'system'),
        ('family',       NULL, N'家庭', 'system'),
        ('travel',       NULL, N'旅遊', 'system'),
        ('relationship', NULL, N'感情', 'system'),
        ('food',         NULL, N'美食', 'system');
END
GO

/* =========================================================
   插入使用者自訂標籤
   ========================================================= */
INSERT INTO dbo.Tag
    (TagId, UserId, TagName, TagType)
VALUES
    -- 使用者1 自訂標籤
    ('custom_hobby_001',    1, N'興趣愛好', 'custom'),
    ('custom_learning_001', 1, N'學習進度', 'custom'),
    ('custom_health_001',   1, N'身體狀況', 'custom'),
    -- 使用者2 自訂標籤
    ('custom_hobby_002',    2, N'運動紀錄',   'custom'),
    ('custom_project_002',  2, N'專案進行',   'custom'),
    ('custom_mood_002',     2, N'心情筆記',   'custom'),
    ('custom_health_002',   2, N'健康管理',   'custom'); 
GO

/* =========================================================
   插入情緒選項
   ========================================================= */
INSERT INTO dbo.Mood
    (MoodId, MoodName, MoodEmoji, IsPositive, IsHighEnergy)
VALUES
    ('happy',    N'開心', N'😄', 1, 1),
    ('excited',  N'興奮', N'🤩', 1, 1),
    ('joyful',   N'幸福', N'🥰', 1, 1),
    ('calm',     N'平靜', N'😌', 1, 0),
    ('relaxed',  N'放鬆', N'🙏', 1, 0),
    ('touched',  N'感動', N'🥹', 1, 0),
    ('angry',    N'生氣', N'😠', 0, 1),
    ('anxious',  N'焦慮', N'😰', 0, 1),
    ('troubled', N'困擾', N'😣', 0, 1),
    ('sad',      N'低落', N'😢', 0, 0),
    ('tired',    N'疲累', N'🥱', 0, 0),
    ('lonely',   N'孤單', N'🥺', 0, 0);
GO

/* =========================================================
   使用者1
   40篇日記（20篇一般 + 20篇心情）
   日期分散：2026-01-01 ~ 2026-05-05
   ========================================================= */
SET IDENTITY_INSERT dbo.Diary ON;
GO

-- DiaryId 1-20：一般日記
INSERT INTO dbo.Diary
    (DiaryId, UserId, TemplateType, PreviewText, DiaryDate, DiaryTime,
     WeatherType, Visibility, Status, CreatedAt)
VALUES
    (1,  1, 'normal', N'新年新計畫，整理工作清單。',               '2026-01-01', '09:30:00', 'sunny',  'private', 'published', '2026-01-01 10:00:00'),
    (2,  1, 'normal', N'完成了API設計文檔第一版。',                '2026-01-05', '10:15:00', 'cloudy', 'shared',  'published', '2026-01-05 11:00:00'),
    (3,  1, 'normal', N'讀了技術文章，學到新的架構模式。',         '2026-01-10', '20:45:00', 'rainy',  'private', 'draft',     '2026-01-10 21:15:00'),
    (4,  1, 'normal', N'團隊會議討論新功能需求。',                 '2026-01-15', '14:00:00', 'sunny',  'shared',  'published', '2026-01-15 14:45:00'),
    (5,  1, 'normal', N'解決了一個困擾多天的bug。',                '2026-01-20', '16:20:00', 'cloudy', 'private', 'published', '2026-01-20 16:50:00'),
    (6,  1, 'normal', N'與家人在新餐廳聚餐。',                     '2026-02-01', '18:30:00', 'sunny',  'shared',  'published', '2026-02-01 19:15:00'),
    (7,  1, 'normal', N'參加了公司技能分享會。',                   '2026-02-08', '14:20:00', 'cloudy', 'private', 'published', '2026-02-08 15:10:00'),
    (8,  1, 'normal', N'整理了辦公桌，工作效率提升。',             '2026-02-15', '08:45:00', 'rainy',  'private', 'draft',     '2026-02-15 09:30:00'),
    (9,  1, 'normal', N'看了一部有趣的電影。',                     '2026-02-22', '21:00:00', 'cloudy', 'private', 'published', '2026-02-22 21:45:00'),
    (10, 1, 'normal', N'完成了課程練習題。',                       '2026-03-01', '19:20:00', 'sunny',  'private', 'published', '2026-03-01 20:00:00'),
    (11, 1, 'normal', N'和新同事進行深入溝通。',                   '2026-03-08', '15:10:00', 'cloudy', 'shared',  'published', '2026-03-08 15:50:00'),
    (12, 1, 'normal', N'試做了新食譜，家人都說好吃。',             '2026-03-15', '18:00:00', 'sunny',  'private', 'draft',     '2026-03-15 18:45:00'),
    (13, 1, 'normal', N'參加朋友的生日聚會。',                     '2026-03-20', '19:30:00', 'rainy',  'shared',  'published', '2026-03-20 20:30:00'),
    (14, 1, 'normal', N'整理了年初的照片。',                       '2026-03-25', '14:45:00', 'cloudy', 'private', 'published', '2026-03-25 15:30:00'),
    (15, 1, 'normal', N'收到期待已久的書籍。',                     '2026-04-01', '11:25:00', 'sunny',  'private', 'published', '2026-04-01 12:10:00'),
    (16, 1, 'normal', N'春季戶外踏青活動。',                       '2026-04-10', '08:00:00', 'sunny',  'shared',  'published', '2026-04-10 08:45:00'),
    (17, 1, 'normal', N'專案里程碑順利達成。',                     '2026-04-18', '16:30:00', 'cloudy', 'private', 'published', '2026-04-18 17:15:00'),
    (18, 1, 'normal', N'學習新的編程語言特性。',                   '2026-04-25', '19:00:00', 'rainy',  'private', 'draft',     '2026-04-25 20:00:00'),
    (19, 1, 'normal', N'參加技術分享大會。',                       '2026-05-01', '14:30:00', 'sunny',  'shared',  'published', '2026-05-01 15:30:00'),
    (20, 1, 'normal', N'月末工作總結和反思。',                     '2026-05-05', '18:00:00', 'cloudy', 'private', 'published', '2026-05-05 19:00:00');
GO

-- DiaryId 21-40：心情日記
INSERT INTO dbo.Diary
    (DiaryId, UserId, TemplateType, PreviewText, DiaryDate, DiaryTime,
     WeatherType, Visibility, Status, CreatedAt)
VALUES
    (21, 1, 'mood', N'新年新氣象，心情特別好。',                   '2026-01-02', '17:00:00', 'sunny',  'private', 'published', '2026-01-02 17:45:00'),
    (22, 1, 'mood', N'工作壓力有點大。',                           '2026-01-08', '16:30:00', 'cloudy', 'shared',  'published', '2026-01-08 17:15:00'),
    (23, 1, 'mood', N'感到疲倦但滿足。',                           '2026-01-12', '19:10:00', 'rainy',  'private', 'draft',     '2026-01-12 19:55:00'),
    (24, 1, 'mood', N'心情平靜，享受寧靜。',                       '2026-01-18', '20:20:00', 'sunny',  'shared',  'published', '2026-01-18 21:00:00'),
    (25, 1, 'mood', N'非常開心，收到好消息。',                     '2026-01-25', '13:40:00', 'cloudy', 'private', 'published', '2026-01-25 14:25:00'),
    (26, 1, 'mood', N'睡眠不足，精神狀態不佳。',                   '2026-02-03', '08:15:00', 'rainy',  'shared',  'published', '2026-02-03 09:00:00'),
    (27, 1, 'mood', N'工作得到認可，精神高漲。',                   '2026-02-10', '15:50:00', 'sunny',  'private', 'published', '2026-02-10 16:35:00'),
    (28, 1, 'mood', N'面臨新挑戰感到有些焦慮。',                   '2026-02-17', '17:30:00', 'cloudy', 'private', 'draft',     '2026-02-17 18:15:00'),
    (29, 1, 'mood', N'放鬆的一天，無工作困擾。',                   '2026-02-24', '19:45:00', 'sunny',  'shared',  'published', '2026-02-24 20:30:00'),
    (30, 1, 'mood', N'感到孤單，但朋友溫暖了我。',                 '2026-03-03', '21:00:00', 'rainy',  'private', 'published', '2026-03-03 21:45:00'),
    (31, 1, 'mood', N'興奮期待春假到來。',                         '2026-03-10', '18:20:00', 'cloudy', 'shared',  'published', '2026-03-10 19:05:00'),
    (32, 1, 'mood', N'感到疲憊需要休息。',                         '2026-03-18', '22:10:00', 'sunny',  'private', 'published', '2026-03-18 22:55:00'),
    (33, 1, 'mood', N'被某事深深觸動。',                           '2026-03-23', '19:35:00', 'cloudy', 'private', 'draft',     '2026-03-23 20:20:00'),
    (34, 1, 'mood', N'生氣的情緒逐漸平復。',                       '2026-04-02', '16:45:00', 'rainy',  'shared',  'published', '2026-04-02 17:30:00'),
    (35, 1, 'mood', N'平穩充實感到平靜。',                         '2026-04-12', '20:15:00', 'sunny',  'private', 'published', '2026-04-12 21:00:00'),
    (36, 1, 'mood', N'春天的活力充滿身心。',                       '2026-04-20', '07:30:00', 'sunny',  'shared',  'published', '2026-04-20 08:30:00'),
    (37, 1, 'mood', N'完成目標感到成就感。',                       '2026-04-27', '18:00:00', 'cloudy', 'private', 'published', '2026-04-27 19:00:00'),
    (38, 1, 'mood', N'新的一週新的期待。',                         '2026-05-02', '08:00:00', 'sunny',  'shared',  'draft',     '2026-05-02 09:00:00'),
    (39, 1, 'mood', N'感恩這一季的收穫。',                         '2026-05-04', '19:30:00', 'rainy',  'private', 'published', '2026-05-04 20:30:00'),
    (40, 1, 'mood', N'向著新目標邁進。',                           '2026-05-05', '17:00:00', 'cloudy', 'private', 'published', '2026-05-05 18:00:00');
GO

/* =========================================================
   使用者2 
   40篇日記（20篇一般 + 20篇心情）
   日期分散：2026-01-01 ~ 2026-05-05
   ========================================================= */

-- DiaryId 41-60：一般日記
INSERT INTO dbo.Diary
    (DiaryId, UserId, TemplateType, PreviewText, DiaryDate, DiaryTime,
     WeatherType, Visibility, Status, CreatedAt)
VALUES
    (41, 2, 'normal', N'新年第一天去健身房。',                     '2026-01-01', '07:00:00', 'sunny',  'shared',  'published', '2026-01-01 07:45:00'),
    (42, 2, 'normal', N'完成了新年健身計畫。',                     '2026-01-06', '18:45:00', 'cloudy', 'private', 'published', '2026-01-06 19:30:00'),
    (43, 2, 'normal', N'看了場精彩的籃球賽。',                     '2026-01-11', '21:20:00', 'rainy',  'shared',  'draft',     '2026-01-11 22:05:00'),
    (44, 2, 'normal', N'和老闆談了職業規劃。',                     '2026-01-16', '10:30:00', 'sunny',  'private', 'published', '2026-01-16 11:15:00'),
    (45, 2, 'normal', N'學習了設計模式。',                         '2026-01-22', '20:00:00', 'cloudy', 'shared',  'published', '2026-01-22 20:45:00'),
    (46, 2, 'normal', N'和朋友去郊外旅遊。',                       '2026-02-02', '17:10:00', 'sunny',  'private', 'published', '2026-02-02 18:00:00'),
    (47, 2, 'normal', N'專案成功上線。',                           '2026-02-09', '15:50:00', 'rainy',  'shared',  'draft',     '2026-02-09 16:35:00'),
    (48, 2, 'normal', N'參加了技術研討會。',                       '2026-02-16', '14:20:00', 'cloudy', 'private', 'published', '2026-02-16 15:05:00'),
    (49, 2, 'normal', N'整理了資料夾發現舊檔案。',                 '2026-02-23', '11:40:00', 'sunny',  'shared',  'published', '2026-02-23 12:25:00'),
    (50, 2, 'normal', N'發現了新的美食餐廳。',                     '2026-03-04', '19:15:00', 'cloudy', 'private', 'published', '2026-03-04 20:00:00'),
    (51, 2, 'normal', N'和家人進行室內活動。',                     '2026-03-11', '16:30:00', 'rainy',  'shared',  'published', '2026-03-11 17:15:00'),
    (52, 2, 'normal', N'健身目標達成了。',                         '2026-03-18', '18:25:00', 'sunny',  'private', 'draft',     '2026-03-18 19:10:00'),
    (53, 2, 'normal', N'讀完了勵志書籍。',                         '2026-03-25', '21:30:00', 'cloudy', 'shared',  'published', '2026-03-25 22:15:00'),
    (54, 2, 'normal', N'組織了技術分享會。',                       '2026-04-03', '13:45:00', 'sunny',  'private', 'published', '2026-04-03 14:30:00'),
    (55, 2, 'normal', N'規劃了五月目標。',                         '2026-04-08', '19:50:00', 'rainy',  'private', 'published', '2026-04-08 20:35:00'),
    (56, 2, 'normal', N'春季登山活動。',                           '2026-04-14', '08:00:00', 'sunny',  'shared',  'published', '2026-04-14 09:00:00'),
    (57, 2, 'normal', N'完成了新項目。',                           '2026-04-19', '16:00:00', 'cloudy', 'private', 'published', '2026-04-19 17:00:00'),
    (58, 2, 'normal', N'學習了新技術。',                           '2026-04-24', '19:00:00', 'rainy',  'private', 'draft',     '2026-04-24 20:00:00'),
    (59, 2, 'normal', N'參加年度會議。',                           '2026-05-01', '10:00:00', 'sunny',  'shared',  'published', '2026-05-01 11:00:00'),
    (60, 2, 'normal', N'月末總結與新計畫。',                       '2026-05-05', '15:00:00', 'cloudy', 'private', 'published', '2026-05-05 16:00:00');
GO

-- DiaryId 61-80：心情日記
INSERT INTO dbo.Diary
    (DiaryId, UserId, TemplateType, PreviewText, DiaryDate, DiaryTime,
     WeatherType, Visibility, Status, CreatedAt)
VALUES
    (61, 2, 'mood', N'新年新氣象，運動後心情舒暢。',               '2026-01-03', '19:00:00', 'sunny',  'shared',  'published', '2026-01-03 19:45:00'),
    (62, 2, 'mood', N'工作順利進展。',                             '2026-01-09', '17:10:00', 'cloudy', 'private', 'published', '2026-01-09 17:55:00'),
    (63, 2, 'mood', N'感到有些失落。',                             '2026-01-14', '20:30:00', 'rainy',  'shared',  'draft',     '2026-01-14 21:15:00'),
    (64, 2, 'mood', N'很平靜享受寧靜。',                           '2026-01-19', '21:40:00', 'sunny',  'private', 'published', '2026-01-19 22:25:00'),
    (65, 2, 'mood', N'興奮不已有新想法。',                         '2026-01-26', '14:20:00', 'cloudy', 'shared',  'published', '2026-01-26 15:05:00'),
    (66, 2, 'mood', N'感到疲憊需要休息。',                         '2026-02-04', '09:00:00', 'rainy',  'private', 'published', '2026-02-04 09:45:00'),
    (67, 2, 'mood', N'被朋友的支持感動。',                         '2026-02-12', '16:15:00', 'sunny',  'shared',  'published', '2026-02-12 17:00:00'),
    (68, 2, 'mood', N'面臨挑戰感到焦慮。',                         '2026-02-19', '15:35:00', 'cloudy', 'private', 'draft',     '2026-02-19 16:20:00'),
    (69, 2, 'mood', N'完全放鬆沒有壓力。',                         '2026-02-27', '20:10:00', 'sunny',  'shared',  'published', '2026-02-27 20:55:00'),
    (70, 2, 'mood', N'感到孤獨思考人生。',                         '2026-03-06', '21:50:00', 'rainy',  'private', 'published', '2026-03-06 22:35:00'),
    (71, 2, 'mood', N'春天來臨期待更多。',                         '2026-03-13', '18:40:00', 'cloudy', 'shared',  'published', '2026-03-13 19:25:00'),
    (72, 2, 'mood', N'身體疲勞精神不佳。',                         '2026-03-21', '22:20:00', 'sunny',  'private', 'published', '2026-03-21 23:05:00'),
    (73, 2, 'mood', N'被某件事深深觸動。',                         '2026-03-28', '20:00:00', 'cloudy', 'private', 'draft',     '2026-03-28 20:45:00'),
    (74, 2, 'mood', N'過去的怨氣消散了。',                         '2026-04-05', '17:25:00', 'rainy',  'shared',  'published', '2026-04-05 18:10:00'),
    (75, 2, 'mood', N'新月份充滿期待。',                           '2026-04-11', '09:00:00', 'sunny',  'private', 'published', '2026-04-11 10:00:00'),
    (76, 2, 'mood', N'活力充滿身心。',                             '2026-04-16', '07:30:00', 'sunny',  'shared',  'published', '2026-04-16 08:30:00'),
    (77, 2, 'mood', N'完成目標感到成就。',                         '2026-04-21', '18:00:00', 'cloudy', 'private', 'published', '2026-04-21 19:00:00'),
    (78, 2, 'mood', N'新的一週新期待。',                           '2026-04-28', '08:00:00', 'sunny',  'shared',  'draft',     '2026-04-28 09:00:00'),
    (79, 2, 'mood', N'感恩這季的收穫。',                           '2026-05-02', '19:30:00', 'rainy',  'private', 'published', '2026-05-02 20:30:00'),
    (80, 2, 'mood', N'向著新目標邁進。',                           '2026-05-05', '17:00:00', 'cloudy', 'private', 'published', '2026-05-05 18:00:00');
GO

SET IDENTITY_INSERT dbo.Diary OFF;
GO

/* =========================================================
   插入一般日記內容（DiaryNormal）：40筆
   ========================================================= */
INSERT INTO dbo.DiaryNormal
    (DiaryId, Title, Body)
VALUES
    -- 使用者1的20篇一般日記
    (1,  N'新年計畫',     N'新年第一天，整理了2026年的工作清單和個人目標。這一年要在技術深度和廣度上都有提升。'),
    (2,  N'API設計完成',   N'完成了新功能的API設計文檔。API採用RESTful風格，包含完整的錯誤處理和速率限制機制。'),
    (3,  N'技術學習筆記',  N'讀了微服務架構文章，學到了服務治理和故障恢復的最佳實踐。對分佈式追蹤工具特別感興趣。'),
    (4,  N'團隊會議',     N'參加了新年規劃會議，討論了今年的技術方向和團隊擴展計畫。'),
    (5,  N'除錯成功',     N'解決了困擾多日的記憶體洩漏問題，優化後系統效能提升了30%。'),
    (6,  N'家庭聚餐',     N'和家人在新開的餐廳聚餐，一起聊了近期的工作和生活。'),
    (7,  N'技能分享',     N'參加了公司技能分享會，容器化部署的講座讓我獲益匪淺。'),
    (8,  N'工作環境改造', N'整理辦公桌，設置了更好的照明。整潔的環境讓工作效率大幅提高。'),
    (9,  N'電影觀影',     N'看了部科幻電影，其中關於AI倫理的探討引發了我的思考。'),
    (10, N'課程進度',     N'完成了線上課程第五章，高級資料結構的內容深度和難度都很大。'),
    (11, N'新同事交流',   N'幫助新同事了解團隊流程，也從他的角度重新認識了我們的系統架構。'),
    (12, N'烹飪實驗',     N'嘗試了新食譜，結果比預期更成功。家人都讚不絕口。'),
    (13, N'朋友聚會',     N'參加友人生日聚會，大家一起玩遊戲唱歌，氣氛歡樂溫馨。'),
    (14, N'照片整理',     N'花時間整理了年初的照片和影片，回憶了許多美好時光。'),
    (15, N'書籍到達',     N'收到期待已久的技術書籍，翻了目錄和前幾章已迫不及待。'),
    (16, N'春季踏青',     N'和團隊進行春季戶外踏青活動，感受到大自然的魅力。'),
    (17, N'專案里程碑',   N'新專案順利達成重要里程碑，整個團隊為此感到自豪。'),
    (18, N'編程語言學習', N'深入學習了新編程語言的高級特性，拓展了開發思路。'),
    (19, N'技術大會',     N'參加了年度技術分享大會，接觸到了很多前沿的技術和想法。'),
    (20, N'月末反思',     N'五月接近尾聲，對這個月的工作進行了總結和反思。'),

    -- 使用者2的20篇一般日記
    (41, N'新年健身',     N'新年第一天就去健身房，決心要把健身當作今年的重點事項。'),
    (42, N'健身計畫',     N'完成了第一週的健身計畫，肌肉有明顯的泵感和酸脹感。'),
    (43, N'籃球觀賞',     N'看了場精彩的籃球比賽直播，兩隊實力不相上下，非常激烈。'),
    (44, N'職業規劃',     N'和老闆談了職業發展，得到了明確的晉升路線和期望。'),
    (45, N'設計模式',     N'學習了觀察者模式，通過編碼練習加深了理解。'),
    (46, N'郊外旅遊',     N'和朋友去郊外旅遊，拍了很多風景照，發現了新的登山路線。'),
    (47, N'項目交付',     N'成功交付了一個挑戰性的項目，解決了許多技術難題。'),
    (48, N'研討會學習',   N'參加了行業技術研討會，學到了前沿的發展方向和最佳實踐。'),
    (49, N'檔案整理',     N'花時間整理電腦資料夾，發現了遺忘的舊項目和有趣的檔案。'),
    (50, N'美食發現',     N'找到了一家環境舒適食物美味的新餐廳，決定常去光顧。'),
    (51, N'家庭活動',     N'和家人進行室內活動，玩棋牌遊戲度過了歡樂時光。'),
    (52, N'健身成就',     N'達成了自己設定的健身目標，體重和體脂率都達到了預定水準。'),
    (53, N'書籍閱讀',     N'讀完了一本激勵人心的自傳，書中經歷讓我反思人生目標。'),
    (54, N'分享會組織',   N'在公司組織了技術知識分享會，和同事分享了實用技巧。'),
    (55, N'五月計畫',     N'規劃了五月的目標，包括工作、學習和運動等多方面。'),
    (56, N'春季登山',     N'參加了春季登山活動，欣賞了山上的春花盛開美景。'),
    (57, N'新項目完成',   N'新項目順利完成並上線，得到了客戶的好評。'),
    (58, N'技術學習',     N'深入學習了新興的編程技術和框架。'),
    (59, N'年度會議',     N'參加了公司年度會議，了解了公司的發展方向和新計畫。'),
    (60, N'月末總結',     N'進行了五月的工作總結，為新月份做好準備。');
GO

/* =========================================================
   插入心情日記內容（DiaryMood）：40筆
   ========================================================= */
INSERT INTO dbo.DiaryMood
    (DiaryId, EnergyValue, StressValue, SleepValue, EventNote, ThoughtNote, NeedNote)
VALUES
    -- 使用者1的20篇心情日記
    (21, 8, 2, 8, N'新年新氣象。',                 N'充滿了對新年的期待。',           N'保持這種積極心態。'),
    (22, 5, 5, 6, N'工作壓力有點大。',             N'但相信能逐漸適應。',             N'需要更多的放鬆時間。'),
    (23, 4, 7, 5, N'遇到了困難。',                 N'感到疲倦但不放棄。',             N'尋找排解壓力的方法。'),
    (24, 6, 4, 8, N'沒有特別事件。',               N'心態平和思緒清晰。',             N'經常留下獨處時間。'),
    (25, 9, 1, 8, N'接到了好消息。',               N'心情非常愉快。',                 N'分享喜悅與他人。'),
    (26, 3, 8, 4, N'睡眠不足。',                   N'精神狀態不佳。',                 N'改善睡眠品質。'),
    (27, 7, 3, 7, N'工作獲得認可。',               N'被認可提升自信。',               N'轉化為持續進步。'),
    (28, 5, 6, 6, N'面臨新挑戰。',                 N'感到有些壓力。',                 N'做好充分準備。'),
    (29, 7, 2, 8, N'完全放鬆。',                   N'享受寧靜時光。',                 N'定期安排休息日。'),
    (30, 4, 5, 7, N'感到孤獨。',                   N'朋友問候溫暖我。',               N'主動聯繫朋友。'),
    (31, 8, 1, 8, N'期待春天。',                   N'興奮不已。',                     N'好好享受時光。'),
    (32, 2, 4, 3, N'工作和生活疲憊。',             N'體力透支。',                     N'優先休息恢復。'),
    (33, 6, 3, 7, N'被某事觸動。',                 N'感受人性溫暖。',                 N'保持感恩心態。'),
    (34, 5, 4, 6, N'對過去有遺憾。',               N'學會理解他人。',                 N'放下展望未來。'),
    (35, 6, 2, 7, N'平穩充實。',                   N'感到內心平靜。',                 N'迎接新月份。'),
    (36, 8, 2, 8, N'春季活力。',                   N'充滿朝氣。',                     N'保持活力狀態。'),
    (37, 7, 3, 7, N'完成里程碑。',                 N'感到成就感。',                   N'設定新目標。'),
    (38, 6, 4, 6, N'學習新技術。',                 N'思路更開闊。',                   N'持續學習進步。'),
    (39, 7, 2, 7, N'充實一天。',                   N'收穫滿滿。',                     N'反思所學。'),
    (40, 6, 3, 7, N'邁向新目標。',                 N'充滿信心。',                     N'執行計畫檢視。'),

    -- 使用者2的20篇心情日記
    (61, 9, 1, 8, N'新年運動活力充沛。',           N'身心輕盈愉快。',                 N'繼續保持習慣。'),
    (62, 7, 3, 7, N'訓練進展順利。',               N'感受身體變化。',                 N'保持一致性。'),
    (63, 5, 6, 7, N'賽事結果遺憾。',               N'學到新東西。',                   N'下次更努力。'),
    (64, 6, 4, 8, N'職業發展指引。',               N'充滿期待。',                     N'朝目標前進。'),
    (65, 7, 3, 7, N'學習充實感。',                 N'大腦活躍。',                     N'深化技能。'),
    (66, 8, 2, 8, N'旅遊充滿樂趣。',               N'發現新地點。',                   N'定期戶外活動。'),
    (67, 8, 2, 8, N'項目完成。',                   N'成就感爆棚。',                   N'慶祝並總結。'),
    (68, 6, 4, 7, N'研討會學習。',                 N'視野開闊。',                     N'應用新知識。'),
    (69, 6, 3, 7, N'檔案整理發現。',               N'回憶往事溫馨。',                 N'定期管理。'),
    (70, 7, 2, 7, N'美食驚喜。',                   N'味蕾滿足。',                     N'探索新餐廳。'),
    (71, 6, 4, 7, N'家庭時光。',                   N'安心放心。',                     N'定期家庭活動。'),
    (72, 9, 1, 8, N'健身目標達成。',               N'自律成就感強。',                 N'設定新目標。'),
    (73, 6, 3, 7, N'書籍啟發。',                   N'思想突破。',                     N'繼續閱讀。'),
    (74, 7, 2, 7, N'知識分享成就。',               N'幫助他人自己。',                 N'定期分享。'),
    (75, 6, 3, 7, N'計畫帶來清晰。',               N'對未來信心。',                   N'執行檢視。'),
    (76, 8, 1, 8, N'新月份期待。',                 N'充滿希望。',                     N'積極面對。'),
    (77, 7, 2, 7, N'完成新項目。',                 N'能力提升。',                     N'接受新挑戰。'),
    (78, 6, 4, 6, N'學習和成長。',                 N'收穫豐富。',                     N'持續精進。'),
    (79, 7, 2, 7, N'感恩季節收穫。',               N'珍惜時光。',                     N'新月新開始。'),
    (80, 6, 3, 7, N'新目標邁進。',                 N'蓄勢待發。',                     N'全力以赴。');
GO

/* =========================================================
   插入日記標籤對應（DiaryTag）
   ========================================================= */
INSERT INTO dbo.DiaryTag
    (DiaryId, TagId)
VALUES
    -- 使用者1 的日記標籤
    (1,  'work'),              (1,  'custom_learning_001'),
    (2,  'work'),              (2,  'custom_learning_001'),
    (3,  'custom_learning_001'),
    (4,  'work'),              (4,  'relationship'),
    (5,  'work'),              (5,  'custom_hobby_001'),
    (6,  'family'),            (6,  'relationship'),
    (7,  'work'),
    (8,  'custom_hobby_001'),
    (9,  'custom_hobby_001'),
    (10, 'custom_learning_001'),
    (11, 'work'),              (11, 'relationship'),
    (12, 'food'),              (12, 'family'),
    (13, 'relationship'),      (13, 'custom_hobby_001'),
    (14, 'custom_hobby_001'),
    (15, 'custom_learning_001'),(15, 'custom_hobby_001'),
    (16, 'travel'),            (16, 'custom_health_001'),
    (17, 'work'),
    (18, 'custom_learning_001'),
    (19, 'work'),              (19, 'relationship'),
    (20, 'custom_hobby_001'),
    (21, 'custom_health_001'),
    (22, 'work'),              (22, 'custom_mood_002'),
    (23, 'work'),              (23, 'custom_learning_001'),
    (24, 'custom_hobby_001'),  (24, 'custom_health_001'),
    (25, 'relationship'),
    (26, 'travel'),            (26, 'custom_hobby_001'),
    (27, 'work'),              (27, 'custom_health_001'),
    (28, 'relationship'),      (28, 'custom_hobby_001'),
    (29, 'work'),              (29, 'relationship'),
    (30, 'custom_hobby_001'),  (30, 'custom_health_001'),
    (31, 'work'),              (31, 'custom_learning_001'),
    (32, 'work'),              (32, 'custom_health_001'),
    (33, 'relationship'),
    (34, 'work'),              (34, 'relationship'),
    (35, 'custom_hobby_001'),
    (36, 'custom_hobby_001'),
    (37, 'work'),
    (38, 'custom_learning_001'),
    (39, 'custom_hobby_001'),
    (40, 'work'),

    -- 使用者2 的日記標籤
    (41, 'custom_health_002'), (41, 'custom_hobby_002'),
    (42, 'custom_health_002'), (42, 'custom_project_002'),
    (43, 'custom_hobby_002'),  (43, 'custom_mood_002'),
    (44, 'work'),              (44, 'custom_project_002'),
    (45, 'custom_project_002'), (45, 'custom_hobby_002'),
    (46, 'travel'),            (46, 'custom_hobby_002'),
    (47, 'work'),              (47, 'custom_project_002'),
    (48, 'work'),              (48, 'custom_mood_002'),
    (49, 'custom_project_002'),
    (50, 'food'),
    (51, 'family'),            (51, 'custom_hobby_002'),
    (52, 'custom_health_002'), (52, 'custom_project_002'),
    (53, 'custom_project_002'), (53, 'custom_mood_002'),
    (54, 'work'),              (54, 'custom_project_002'),
    (55, 'custom_project_002'), (55, 'custom_hobby_002'),
    (56, 'travel'),            (56, 'custom_hobby_002'),
    (57, 'work'),              (57, 'custom_project_002'),
    (58, 'custom_learning_001'),
    (59, 'work'),              (59, 'relationship'),
    (60, 'custom_hobby_002'),
    (61, 'custom_health_002'), (61, 'custom_mood_002'),
    (62, 'custom_health_002'), (62, 'custom_project_002'),
    (63, 'custom_hobby_002'),  (63, 'custom_mood_002'),
    (64, 'work'),              (64, 'custom_project_002'),
    (65, 'custom_project_002'), (65, 'custom_hobby_002'),
    (66, 'travel'),            (66, 'custom_hobby_002'),
    (67, 'work'),              (67, 'custom_project_002'),
    (68, 'work'),              (68, 'custom_mood_002'),
    (69, 'custom_project_002'),
    (70, 'food'),
    (71, 'family'),            (71, 'custom_hobby_002'),
    (72, 'custom_health_002'), (72, 'custom_project_002'),
    (73, 'custom_project_002'), (73, 'custom_mood_002'),
    (74, 'work'),              (74, 'custom_project_002'),
    (75, 'custom_project_002'), (75, 'custom_hobby_002'),
    (76, 'travel'),            (76, 'custom_hobby_002'),
    (77, 'work'),              (77, 'custom_project_002'),
    (78, 'custom_learning_001'),
    (79, 'work'),              (79, 'relationship'),
    (80, 'custom_hobby_002');
GO

/* =========================================================
   插入心情日記情緒對應（DiaryMoodSelection）：80筆
   ========================================================= */
INSERT INTO dbo.DiaryMoodSelection
    (DiaryId, MoodId)
VALUES
    -- 使用者1的20篇心情日記情緒
    (21, 'happy'),    (21, 'excited'),  (21, 'joyful'),
    (22, 'calm'),     (22, 'anxious'),
    (23, 'tired'),    (23, 'anxious'),
    (24, 'calm'),     (24, 'touched'),
    (25, 'excited'),  (25, 'happy'),    (25, 'joyful'),
    (26, 'tired'),    (26, 'sad'),
    (27, 'happy'),    (27, 'joyful'),   (27, 'excited'),
    (28, 'anxious'),  (28, 'calm'),
    (29, 'calm'),     (29, 'relaxed'),
    (30, 'lonely'),   (30, 'touched'),
    (31, 'excited'),  (31, 'happy'),
    (32, 'tired'),    (32, 'sad'),
    (33, 'touched'),  (33, 'joyful'),
    (34, 'calm'),     (34, 'relaxed'),
    (35, 'calm'),     (35, 'happy'),
    (36, 'happy'),    (36, 'excited'),  (36, 'joyful'),
    (37, 'happy'),    (37, 'calm'),
    (38, 'sad'),      (38, 'anxious'),
    (39, 'happy'),    (39, 'excited'),
    (40, 'joyful'),   (40, 'excited'),

    -- 使用者2的20篇心情日記情緒
    (61, 'happy'),    (61, 'excited'),  (61, 'joyful'),
    (62, 'happy'),    (62, 'calm'),
    (63, 'sad'),      (63, 'anxious'),
    (64, 'happy'),    (64, 'excited'),
    (65, 'joyful'),   (65, 'excited'),
    (66, 'happy'),    (66, 'excited'),  (66, 'joyful'),
    (67, 'happy'),    (67, 'excited'),  (67, 'joyful'),
    (68, 'calm'),     (68, 'happy'),
    (69, 'touched'),  (69, 'calm'),
    (70, 'happy'),    (70, 'joyful'),
    (71, 'happy'),    (71, 'touched'),
    (72, 'happy'),    (72, 'excited'),  (72, 'joyful'),
    (73, 'touched'),  (73, 'calm'),
    (74, 'happy'),    (74, 'joyful'),
    (75, 'calm'),     (75, 'happy'),    (75, 'joyful'),
    (76, 'happy'),    (76, 'excited'),
    (77, 'joyful'),   (77, 'excited'),
    (78, 'happy'),    (78, 'calm'),
    (79, 'touched'),  (79, 'joyful'),
    (80, 'calm'),     (80, 'happy'),    (80, 'excited');
GO

/* =========================================================
   插入媒體資料（DiaryMedia）
   ========================================================= */
INSERT INTO dbo.DiaryMedia
    (MediaId, DiaryId, MediaType, FileUrl, CreatedAt)
VALUES
-- 為所有 80 篇日記分配媒體（20張媒體循環分配）
-- .jpg圖片檔 x10張 .png繪圖檔 x10張

-- 使用者1的日記（DiaryId 1-40）
('media_001', 1,  'image',   '/image/media_001.jpg',   '2026-01-01 08:00:00'),
('media_002', 3,  'image',   '/image/media_002.jpg',   '2026-01-11 14:00:00'),
('media_003', 5,  'image',   '/image/media_003.jpg',   '2026-01-22 20:00:00'),
('media_004', 6,  'image',   '/image/media_004.jpg',   '2026-02-02 18:00:00'),
('media_005', 8,  'image',   '/image/media_005.jpg',   '2026-02-16 15:00:00'),
('media_006', 10, 'image',   '/image/media_006.jpg',   '2026-03-04 20:00:00'),
('media_007', 12, 'image',   '/image/media_007.jpg',   '2026-03-18 19:00:00'),
('media_008', 14, 'image',   '/image/media_008.jpg',   '2026-03-25 22:00:00'),
('media_009', 16, 'image',   '/image/media_009.jpg',   '2026-04-03 14:00:00'),
('media_010', 18, 'image',   '/image/media_010.jpg',   '2026-04-08 20:00:00'),
('media_011', 20, 'drawing', '/drawing/media_011.png', '2026-05-05 16:00:00'),
('media_012', 2,  'drawing', '/drawing/media_012.png', '2026-01-06 19:00:00'),
('media_013', 4,  'drawing', '/drawing/media_013.png', '2026-01-16 11:00:00'),
('media_014', 7,  'drawing', '/drawing/media_014.png', '2026-02-09 16:00:00'),
('media_015', 9,  'drawing', '/drawing/media_015.png', '2026-02-23 12:00:00'),
('media_016', 11, 'drawing', '/drawing/media_016.png', '2026-03-11 17:00:00'),
('media_017', 13, 'drawing', '/drawing/media_017.png', '2026-03-28 21:00:00'),
('media_018', 15, 'drawing', '/drawing/media_018.png', '2026-04-14 09:00:00'),
('media_019', 17, 'drawing', '/drawing/media_019.png', '2026-04-19 17:00:00'),
('media_020', 19, 'drawing', '/drawing/media_020.png', '2026-04-24 20:00:00'),

-- 使用者2的日記（DiaryId 41-80）循環使用 media_001-020
('media_021', 41, 'image',   '/image/media_001.jpg',   '2026-01-01 08:00:00'),
('media_022', 43, 'image',   '/image/media_002.jpg',   '2026-01-11 22:00:00'),
('media_023', 45, 'image',   '/image/media_003.jpg',   '2026-01-22 14:00:00'),
('media_024', 46, 'image',   '/image/media_004.jpg',   '2026-02-02 18:00:00'),
('media_025', 48, 'image',   '/image/media_005.jpg',   '2026-02-16 15:00:00'),
('media_026', 50, 'image',   '/image/media_006.jpg',   '2026-03-04 20:00:00'),
('media_027', 52, 'image',   '/image/media_007.jpg',   '2026-03-18 19:00:00'),
('media_028', 54, 'image',   '/image/media_008.jpg',   '2026-03-25 14:00:00'),
('media_029', 56, 'image',   '/image/media_009.jpg',   '2026-04-03 09:00:00'),
('media_030', 58, 'image',   '/image/media_010.jpg',   '2026-04-08 19:00:00'),
('media_031', 60, 'drawing', '/drawing/media_011.png', '2026-05-05 16:00:00'),
('media_032', 42, 'drawing', '/drawing/media_012.png', '2026-01-06 20:00:00'),
('media_033', 44, 'drawing', '/drawing/media_013.png', '2026-01-16 11:00:00'),
('media_034', 47, 'drawing', '/drawing/media_014.png', '2026-02-09 17:00:00'),
('media_035', 49, 'drawing', '/drawing/media_015.png', '2026-02-23 20:00:00'),
('media_036', 51, 'drawing', '/drawing/media_016.png', '2026-03-11 09:00:00'),
('media_037', 53, 'drawing', '/drawing/media_017.png', '2026-03-28 14:00:00'),
('media_038', 55, 'drawing', '/drawing/media_018.png', '2026-04-14 13:00:00'),
('media_039', 57, 'drawing', '/drawing/media_019.png', '2026-04-19 16:00:00'),
('media_040', 59, 'drawing', '/drawing/media_020.png', '2026-04-24 19:00:00');
GO

/* =========================================================
   插入回應計數（PostReactionCount）：
   使用者1 + 使用者2 共80筆日記 × 5種反應
   ========================================================= */
INSERT INTO dbo.PostReactionCount
    (DiaryId, ReactionType, Count, UpdatedAt)
VALUES
    (1, 'like', 12, SYSUTCDATETIME()), (1, 'love', 8, SYSUTCDATETIME()), (1, 'hug', 6, SYSUTCDATETIME()), (1, 'empathy', 4, SYSUTCDATETIME()), (1, 'cheer', 10, SYSUTCDATETIME()),
    (2, 'like', 16, SYSUTCDATETIME()), (2, 'love', 9, SYSUTCDATETIME()), (2, 'hug', 7, SYSUTCDATETIME()), (2, 'empathy', 5, SYSUTCDATETIME()), (2, 'cheer', 11, SYSUTCDATETIME()),
    (3, 'like', 14, SYSUTCDATETIME()), (3, 'love', 10, SYSUTCDATETIME()), (3, 'hug', 8, SYSUTCDATETIME()), (3, 'empathy', 6, SYSUTCDATETIME()), (3, 'cheer', 9, SYSUTCDATETIME()),
    (4, 'like', 18, SYSUTCDATETIME()), (4, 'love', 12, SYSUTCDATETIME()), (4, 'hug', 9, SYSUTCDATETIME()), (4, 'empathy', 7, SYSUTCDATETIME()), (4, 'cheer', 14, SYSUTCDATETIME()),
    (5, 'like', 11, SYSUTCDATETIME()), (5, 'love', 7, SYSUTCDATETIME()), (5, 'hug', 5, SYSUTCDATETIME()), (5, 'empathy', 4, SYSUTCDATETIME()), (5, 'cheer', 8, SYSUTCDATETIME()),
    (6, 'like', 15, SYSUTCDATETIME()), (6, 'love', 11, SYSUTCDATETIME()), (6, 'hug', 8, SYSUTCDATETIME()), (6, 'empathy', 6, SYSUTCDATETIME()), (6, 'cheer', 10, SYSUTCDATETIME()),
    (7, 'like', 13, SYSUTCDATETIME()), (7, 'love', 8, SYSUTCDATETIME()), (7, 'hug', 6, SYSUTCDATETIME()), (7, 'empathy', 4, SYSUTCDATETIME()), (7, 'cheer', 9, SYSUTCDATETIME()),
    (8, 'like', 17, SYSUTCDATETIME()), (8, 'love', 10, SYSUTCDATETIME()), (8, 'hug', 7, SYSUTCDATETIME()), (8, 'empathy', 5, SYSUTCDATETIME()), (8, 'cheer', 12, SYSUTCDATETIME()),
    (9, 'like', 19, SYSUTCDATETIME()), (9, 'love', 12, SYSUTCDATETIME()), (9, 'hug', 9, SYSUTCDATETIME()), (9, 'empathy', 6, SYSUTCDATETIME()), (9, 'cheer', 14, SYSUTCDATETIME()),
    (10, 'like', 12, SYSUTCDATETIME()), (10, 'love', 8, SYSUTCDATETIME()), (10, 'hug', 6, SYSUTCDATETIME()), (10, 'empathy', 5, SYSUTCDATETIME()), (10, 'cheer', 9, SYSUTCDATETIME()),
    (11, 'like', 16, SYSUTCDATETIME()), (11, 'love', 10, SYSUTCDATETIME()), (11, 'hug', 7, SYSUTCDATETIME()), (11, 'empathy', 6, SYSUTCDATETIME()), (11, 'cheer', 11, SYSUTCDATETIME()),
    (12, 'like', 14, SYSUTCDATETIME()), (12, 'love', 9, SYSUTCDATETIME()), (12, 'hug', 7, SYSUTCDATETIME()), (12, 'empathy', 5, SYSUTCDATETIME()), (12, 'cheer', 10, SYSUTCDATETIME()),
    (13, 'like', 20, SYSUTCDATETIME()), (13, 'love', 12, SYSUTCDATETIME()), (13, 'hug', 9, SYSUTCDATETIME()), (13, 'empathy', 7, SYSUTCDATETIME()), (13, 'cheer', 14, SYSUTCDATETIME()),
    (14, 'like', 13, SYSUTCDATETIME()), (14, 'love', 8, SYSUTCDATETIME()), (14, 'hug', 6, SYSUTCDATETIME()), (14, 'empathy', 5, SYSUTCDATETIME()), (14, 'cheer', 9, SYSUTCDATETIME()),
    (15, 'like', 15, SYSUTCDATETIME()), (15, 'love', 9, SYSUTCDATETIME()), (15, 'hug', 7, SYSUTCDATETIME()), (15, 'empathy', 5, SYSUTCDATETIME()), (15, 'cheer', 10, SYSUTCDATETIME()),
    (16, 'like', 18, SYSUTCDATETIME()), (16, 'love', 11, SYSUTCDATETIME()), (16, 'hug', 8, SYSUTCDATETIME()), (16, 'empathy', 6, SYSUTCDATETIME()), (16, 'cheer', 12, SYSUTCDATETIME()),
    (17, 'like', 14, SYSUTCDATETIME()), (17, 'love', 8, SYSUTCDATETIME()), (17, 'hug', 6, SYSUTCDATETIME()), (17, 'empathy', 4, SYSUTCDATETIME()), (17, 'cheer', 9, SYSUTCDATETIME()),
    (18, 'like', 12, SYSUTCDATETIME()), (18, 'love', 10, SYSUTCDATETIME()), (18, 'hug', 7, SYSUTCDATETIME()), (18, 'empathy', 5, SYSUTCDATETIME()), (18, 'cheer', 11, SYSUTCDATETIME()),
    (19, 'like', 16, SYSUTCDATETIME()), (19, 'love', 9, SYSUTCDATETIME()), (19, 'hug', 7, SYSUTCDATETIME()), (19, 'empathy', 5, SYSUTCDATETIME()), (19, 'cheer', 10, SYSUTCDATETIME()),
    (20, 'like', 19, SYSUTCDATETIME()), (20, 'love', 11, SYSUTCDATETIME()), (20, 'hug', 8, SYSUTCDATETIME()), (20, 'empathy', 6, SYSUTCDATETIME()), (20, 'cheer', 13, SYSUTCDATETIME()),
    (21, 'like', 13, SYSUTCDATETIME()), (21, 'love', 8, SYSUTCDATETIME()), (21, 'hug', 6, SYSUTCDATETIME()), (21, 'empathy', 4, SYSUTCDATETIME()), (21, 'cheer', 9, SYSUTCDATETIME()),
    (22, 'like', 17, SYSUTCDATETIME()), (22, 'love', 10, SYSUTCDATETIME()), (22, 'hug', 7, SYSUTCDATETIME()), (22, 'empathy', 5, SYSUTCDATETIME()), (22, 'cheer', 11, SYSUTCDATETIME()),
    (23, 'like', 15, SYSUTCDATETIME()), (23, 'love', 9, SYSUTCDATETIME()), (23, 'hug', 6, SYSUTCDATETIME()), (23, 'empathy', 5, SYSUTCDATETIME()), (23, 'cheer', 10, SYSUTCDATETIME()),
    (24, 'like', 18, SYSUTCDATETIME()), (24, 'love', 11, SYSUTCDATETIME()), (24, 'hug', 8, SYSUTCDATETIME()), (24, 'empathy', 6, SYSUTCDATETIME()), (24, 'cheer', 12, SYSUTCDATETIME()),
    (25, 'like', 14, SYSUTCDATETIME()), (25, 'love', 9, SYSUTCDATETIME()), (25, 'hug', 7, SYSUTCDATETIME()), (25, 'empathy', 5, SYSUTCDATETIME()), (25, 'cheer', 10, SYSUTCDATETIME()),
    (26, 'like', 20, SYSUTCDATETIME()), (26, 'love', 12, SYSUTCDATETIME()), (26, 'hug', 9, SYSUTCDATETIME()), (26, 'empathy', 7, SYSUTCDATETIME()), (26, 'cheer', 14, SYSUTCDATETIME()),
    (27, 'like', 12, SYSUTCDATETIME()), (27, 'love', 7, SYSUTCDATETIME()), (27, 'hug', 5, SYSUTCDATETIME()), (27, 'empathy', 4, SYSUTCDATETIME()), (27, 'cheer', 8, SYSUTCDATETIME()),
    (28, 'like', 16, SYSUTCDATETIME()), (28, 'love', 10, SYSUTCDATETIME()), (28, 'hug', 7, SYSUTCDATETIME()), (28, 'empathy', 5, SYSUTCDATETIME()), (28, 'cheer', 11, SYSUTCDATETIME()),
    (29, 'like', 14, SYSUTCDATETIME()), (29, 'love', 8, SYSUTCDATETIME()), (29, 'hug', 6, SYSUTCDATETIME()), (29, 'empathy', 5, SYSUTCDATETIME()), (29, 'cheer', 9, SYSUTCDATETIME()),
    (30, 'like', 18, SYSUTCDATETIME()), (30, 'love', 11, SYSUTCDATETIME()), (30, 'hug', 8, SYSUTCDATETIME()), (30, 'empathy', 6, SYSUTCDATETIME()), (30, 'cheer', 12, SYSUTCDATETIME()),
    (31, 'like', 15, SYSUTCDATETIME()), (31, 'love', 9, SYSUTCDATETIME()), (31, 'hug', 7, SYSUTCDATETIME()), (31, 'empathy', 5, SYSUTCDATETIME()), (31, 'cheer', 10, SYSUTCDATETIME()),
    (32, 'like', 13, SYSUTCDATETIME()), (32, 'love', 8, SYSUTCDATETIME()), (32, 'hug', 6, SYSUTCDATETIME()), (32, 'empathy', 4, SYSUTCDATETIME()), (32, 'cheer', 9, SYSUTCDATETIME()),
    (33, 'like', 17, SYSUTCDATETIME()), (33, 'love', 10, SYSUTCDATETIME()), (33, 'hug', 8, SYSUTCDATETIME()), (33, 'empathy', 5, SYSUTCDATETIME()), (33, 'cheer', 11, SYSUTCDATETIME()),
    (34, 'like', 14, SYSUTCDATETIME()), (34, 'love', 9, SYSUTCDATETIME()), (34, 'hug', 6, SYSUTCDATETIME()), (34, 'empathy', 5, SYSUTCDATETIME()), (34, 'cheer', 10, SYSUTCDATETIME()),
    (35, 'like', 19, SYSUTCDATETIME()), (35, 'love', 12, SYSUTCDATETIME()), (35, 'hug', 9, SYSUTCDATETIME()), (35, 'empathy', 6, SYSUTCDATETIME()), (35, 'cheer', 13, SYSUTCDATETIME()),
    (36, 'like', 16, SYSUTCDATETIME()), (36, 'love', 11, SYSUTCDATETIME()), (36, 'hug', 8, SYSUTCDATETIME()), (36, 'empathy', 6, SYSUTCDATETIME()), (36, 'cheer', 12, SYSUTCDATETIME()),
    (37, 'like', 20, SYSUTCDATETIME()), (37, 'love', 13, SYSUTCDATETIME()), (37, 'hug', 10, SYSUTCDATETIME()), (37, 'empathy', 7, SYSUTCDATETIME()), (37, 'cheer', 15, SYSUTCDATETIME()),
    (38, 'like', 13, SYSUTCDATETIME()), (38, 'love', 8, SYSUTCDATETIME()), (38, 'hug', 6, SYSUTCDATETIME()), (38, 'empathy', 4, SYSUTCDATETIME()), (38, 'cheer', 9, SYSUTCDATETIME()),
    (39, 'like', 15, SYSUTCDATETIME()), (39, 'love', 9, SYSUTCDATETIME()), (39, 'hug', 7, SYSUTCDATETIME()), (39, 'empathy', 5, SYSUTCDATETIME()), (39, 'cheer', 10, SYSUTCDATETIME()),
    (40, 'like', 18, SYSUTCDATETIME()), (40, 'love', 11, SYSUTCDATETIME()), (40, 'hug', 8, SYSUTCDATETIME()), (40, 'empathy', 6, SYSUTCDATETIME()), (40, 'cheer', 12, SYSUTCDATETIME()),
    (41, 'like', 14, SYSUTCDATETIME()), (41, 'love', 9, SYSUTCDATETIME()), (41, 'hug', 7, SYSUTCDATETIME()), (41, 'empathy', 5, SYSUTCDATETIME()), (41, 'cheer', 10, SYSUTCDATETIME()),
    (42, 'like', 16, SYSUTCDATETIME()), (42, 'love', 10, SYSUTCDATETIME()), (42, 'hug', 8, SYSUTCDATETIME()), (42, 'empathy', 6, SYSUTCDATETIME()), (42, 'cheer', 11, SYSUTCDATETIME()),
    (43, 'like', 13, SYSUTCDATETIME()), (43, 'love', 8, SYSUTCDATETIME()), (43, 'hug', 6, SYSUTCDATETIME()), (43, 'empathy', 4, SYSUTCDATETIME()), (43, 'cheer', 9, SYSUTCDATETIME()),
    (44, 'like', 17, SYSUTCDATETIME()), (44, 'love', 10, SYSUTCDATETIME()), (44, 'hug', 7, SYSUTCDATETIME()), (44, 'empathy', 5, SYSUTCDATETIME()), (44, 'cheer', 11, SYSUTCDATETIME()),
    (45, 'like', 15, SYSUTCDATETIME()), (45, 'love', 9, SYSUTCDATETIME()), (45, 'hug', 7, SYSUTCDATETIME()), (45, 'empathy', 5, SYSUTCDATETIME()), (45, 'cheer', 10, SYSUTCDATETIME()),
    (46, 'like', 18, SYSUTCDATETIME()), (46, 'love', 11, SYSUTCDATETIME()), (46, 'hug', 8, SYSUTCDATETIME()), (46, 'empathy', 6, SYSUTCDATETIME()), (46, 'cheer', 12, SYSUTCDATETIME()),
    (47, 'like', 14, SYSUTCDATETIME()), (47, 'love', 9, SYSUTCDATETIME()), (47, 'hug', 6, SYSUTCDATETIME()), (47, 'empathy', 5, SYSUTCDATETIME()), (47, 'cheer', 9, SYSUTCDATETIME()),
    (48, 'like', 16, SYSUTCDATETIME()), (48, 'love', 10, SYSUTCDATETIME()), (48, 'hug', 7, SYSUTCDATETIME()), (48, 'empathy', 5, SYSUTCDATETIME()), (48, 'cheer', 11, SYSUTCDATETIME()),
    (49, 'like', 13, SYSUTCDATETIME()), (49, 'love', 8, SYSUTCDATETIME()), (49, 'hug', 6, SYSUTCDATETIME()), (49, 'empathy', 4, SYSUTCDATETIME()), (49, 'cheer', 8, SYSUTCDATETIME()),
    (50, 'like', 19, SYSUTCDATETIME()), (50, 'love', 12, SYSUTCDATETIME()), (50, 'hug', 9, SYSUTCDATETIME()), (50, 'empathy', 6, SYSUTCDATETIME()), (50, 'cheer', 13, SYSUTCDATETIME()),
    (51, 'like', 15, SYSUTCDATETIME()), (51, 'love', 9, SYSUTCDATETIME()), (51, 'hug', 7, SYSUTCDATETIME()), (51, 'empathy', 5, SYSUTCDATETIME()), (51, 'cheer', 10, SYSUTCDATETIME()),
    (52, 'like', 17, SYSUTCDATETIME()), (52, 'love', 11, SYSUTCDATETIME()), (52, 'hug', 8, SYSUTCDATETIME()), (52, 'empathy', 6, SYSUTCDATETIME()), (52, 'cheer', 12, SYSUTCDATETIME()),
    (53, 'like', 14, SYSUTCDATETIME()), (53, 'love', 9, SYSUTCDATETIME()), (53, 'hug', 7, SYSUTCDATETIME()), (53, 'empathy', 5, SYSUTCDATETIME()), (53, 'cheer', 10, SYSUTCDATETIME()),
    (54, 'like', 18, SYSUTCDATETIME()), (54, 'love', 11, SYSUTCDATETIME()), (54, 'hug', 8, SYSUTCDATETIME()), (54, 'empathy', 6, SYSUTCDATETIME()), (54, 'cheer', 12, SYSUTCDATETIME()),
    (55, 'like', 16, SYSUTCDATETIME()), (55, 'love', 10, SYSUTCDATETIME()), (55, 'hug', 8, SYSUTCDATETIME()), (55, 'empathy', 6, SYSUTCDATETIME()), (55, 'cheer', 11, SYSUTCDATETIME()),
    (56, 'like', 20, SYSUTCDATETIME()), (56, 'love', 13, SYSUTCDATETIME()), (56, 'hug', 10, SYSUTCDATETIME()), (56, 'empathy', 7, SYSUTCDATETIME()), (56, 'cheer', 14, SYSUTCDATETIME()),
    (57, 'like', 15, SYSUTCDATETIME()), (57, 'love', 9, SYSUTCDATETIME()), (57, 'hug', 7, SYSUTCDATETIME()), (57, 'empathy', 5, SYSUTCDATETIME()), (57, 'cheer', 10, SYSUTCDATETIME()),
    (58, 'like', 17, SYSUTCDATETIME()), (58, 'love', 10, SYSUTCDATETIME()), (58, 'hug', 7, SYSUTCDATETIME()), (58, 'empathy', 5, SYSUTCDATETIME()), (58, 'cheer', 11, SYSUTCDATETIME()),
    (59, 'like', 14, SYSUTCDATETIME()), (59, 'love', 9, SYSUTCDATETIME()), (59, 'hug', 6, SYSUTCDATETIME()), (59, 'empathy', 4, SYSUTCDATETIME()), (59, 'cheer', 9, SYSUTCDATETIME()),
    (60, 'like', 18, SYSUTCDATETIME()), (60, 'love', 11, SYSUTCDATETIME()), (60, 'hug', 8, SYSUTCDATETIME()), (60, 'empathy', 6, SYSUTCDATETIME()), (60, 'cheer', 12, SYSUTCDATETIME()),
    (61, 'like', 16, SYSUTCDATETIME()), (61, 'love', 10, SYSUTCDATETIME()), (61, 'hug', 8, SYSUTCDATETIME()), (61, 'empathy', 6, SYSUTCDATETIME()), (61, 'cheer', 11, SYSUTCDATETIME()),
    (62, 'like', 14, SYSUTCDATETIME()), (62, 'love', 9, SYSUTCDATETIME()), (62, 'hug', 7, SYSUTCDATETIME()), (62, 'empathy', 5, SYSUTCDATETIME()), (62, 'cheer', 10, SYSUTCDATETIME()),
    (63, 'like', 12, SYSUTCDATETIME()), (63, 'love', 8, SYSUTCDATETIME()), (63, 'hug', 6, SYSUTCDATETIME()), (63, 'empathy', 4, SYSUTCDATETIME()), (63, 'cheer', 9, SYSUTCDATETIME()),
    (64, 'like', 17, SYSUTCDATETIME()), (64, 'love', 11, SYSUTCDATETIME()), (64, 'hug', 8, SYSUTCDATETIME()), (64, 'empathy', 6, SYSUTCDATETIME()), (64, 'cheer', 12, SYSUTCDATETIME()),
    (65, 'like', 15, SYSUTCDATETIME()), (65, 'love', 9, SYSUTCDATETIME()), (65, 'hug', 7, SYSUTCDATETIME()), (65, 'empathy', 5, SYSUTCDATETIME()), (65, 'cheer', 10, SYSUTCDATETIME()),
    (66, 'like', 19, SYSUTCDATETIME()), (66, 'love', 12, SYSUTCDATETIME()), (66, 'hug', 9, SYSUTCDATETIME()), (66, 'empathy', 6, SYSUTCDATETIME()), (66, 'cheer', 14, SYSUTCDATETIME()),
    (67, 'like', 18, SYSUTCDATETIME()), (67, 'love', 11, SYSUTCDATETIME()), (67, 'hug', 8, SYSUTCDATETIME()), (67, 'empathy', 6, SYSUTCDATETIME()), (67, 'cheer', 12, SYSUTCDATETIME()),
    (68, 'like', 13, SYSUTCDATETIME()), (68, 'love', 8, SYSUTCDATETIME()), (68, 'hug', 6, SYSUTCDATETIME()), (68, 'empathy', 4, SYSUTCDATETIME()), (68, 'cheer', 9, SYSUTCDATETIME()),
    (69, 'like', 16, SYSUTCDATETIME()), (69, 'love', 10, SYSUTCDATETIME()), (69, 'hug', 7, SYSUTCDATETIME()), (69, 'empathy', 5, SYSUTCDATETIME()), (69, 'cheer', 11, SYSUTCDATETIME()),
    (70, 'like', 14, SYSUTCDATETIME()), (70, 'love', 9, SYSUTCDATETIME()), (70, 'hug', 6, SYSUTCDATETIME()), (70, 'empathy', 5, SYSUTCDATETIME()), (70, 'cheer', 10, SYSUTCDATETIME()),
    (71, 'like', 17, SYSUTCDATETIME()), (71, 'love', 11, SYSUTCDATETIME()), (71, 'hug', 8, SYSUTCDATETIME()), (71, 'empathy', 6, SYSUTCDATETIME()), (71, 'cheer', 12, SYSUTCDATETIME()),
    (72, 'like', 15, SYSUTCDATETIME()), (72, 'love', 9, SYSUTCDATETIME()), (72, 'hug', 7, SYSUTCDATETIME()), (72, 'empathy', 5, SYSUTCDATETIME()), (72, 'cheer', 10, SYSUTCDATETIME()),
    (73, 'like', 18, SYSUTCDATETIME()), (73, 'love', 11, SYSUTCDATETIME()), (73, 'hug', 8, SYSUTCDATETIME()), (73, 'empathy', 6, SYSUTCDATETIME()), (73, 'cheer', 12, SYSUTCDATETIME()),
    (74, 'like', 16, SYSUTCDATETIME()), (74, 'love', 10, SYSUTCDATETIME()), (74, 'hug', 8, SYSUTCDATETIME()), (74, 'empathy', 6, SYSUTCDATETIME()), (74, 'cheer', 11, SYSUTCDATETIME()),
    (75, 'like', 19, SYSUTCDATETIME()), (75, 'love', 12, SYSUTCDATETIME()), (75, 'hug', 9, SYSUTCDATETIME()), (75, 'empathy', 6, SYSUTCDATETIME()), (75, 'cheer', 14, SYSUTCDATETIME()),
    (76, 'like', 17, SYSUTCDATETIME()), (76, 'love', 11, SYSUTCDATETIME()), (76, 'hug', 8, SYSUTCDATETIME()), (76, 'empathy', 6, SYSUTCDATETIME()), (76, 'cheer', 12, SYSUTCDATETIME()),
    (77, 'like', 14, SYSUTCDATETIME()), (77, 'love', 9, SYSUTCDATETIME()), (77, 'hug', 7, SYSUTCDATETIME()), (77, 'empathy', 5, SYSUTCDATETIME()), (77, 'cheer', 10, SYSUTCDATETIME()),
    (78, 'like', 16, SYSUTCDATETIME()), (78, 'love', 10, SYSUTCDATETIME()), (78, 'hug', 8, SYSUTCDATETIME()), (78, 'empathy', 6, SYSUTCDATETIME()), (78, 'cheer', 11, SYSUTCDATETIME()),
    (79, 'like', 13, SYSUTCDATETIME()), (79, 'love', 8, SYSUTCDATETIME()), (79, 'hug', 6, SYSUTCDATETIME()), (79, 'empathy', 4, SYSUTCDATETIME()), (79, 'cheer', 9, SYSUTCDATETIME()),
    (80, 'like', 18, SYSUTCDATETIME()), (80, 'love', 11, SYSUTCDATETIME()), (80, 'hug', 8, SYSUTCDATETIME()), (80, 'empathy', 6, SYSUTCDATETIME()), (80, 'cheer', 12, SYSUTCDATETIME());
GO



