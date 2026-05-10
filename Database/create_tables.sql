/* =========================================================
   日記管理系統 - SQL Server 建表

   配合組員設計的 User表 修正：
   - Diary.UserId / Tag.UserId / DiaryReaction.UserId 由 BIGINT 改為 INT
     以對應 User.UserId INT IDENTITY(1,1)，避免 FK 型別不一致錯誤
   ========================================================= */

SET XACT_ABORT ON;
GO

/* 建立資料庫（若不存在）並切換使用 */
IF DB_ID(N'DiarySystemDB') IS NULL
BEGIN
    CREATE DATABASE [DiarySystemDB];
END
GO

USE [DiarySystemDB];
GO

/* 先刪除既有資料表 */
DROP TABLE IF EXISTS dbo.DiaryReaction;
DROP TABLE IF EXISTS dbo.DiaryMedia;
DROP TABLE IF EXISTS dbo.DiaryTag;
DROP TABLE IF EXISTS dbo.DiaryMoodSelection;
DROP TABLE IF EXISTS dbo.DiaryMood;
DROP TABLE IF EXISTS dbo.DiaryNormal;
DROP TABLE IF EXISTS dbo.Tag;
DROP TABLE IF EXISTS dbo.Mood;
DROP TABLE IF EXISTS dbo.Diary;
DROP TABLE IF EXISTS dbo.[User];
GO

/* =========================================================
   0. User 使用者表（其他組員負責，保留結構供 FK 使用）
   ========================================================= */
CREATE TABLE dbo.[User]
(
    UserId                  INT          IDENTITY(1,1) NOT NULL,
    Email                   NVARCHAR(MAX) COLLATE Chinese_Taiwan_Stroke_CI_AS NOT NULL,
    Password                NVARCHAR(MAX) COLLATE Chinese_Taiwan_Stroke_CI_AS NOT NULL,
    Phone                   NVARCHAR(MAX) COLLATE Chinese_Taiwan_Stroke_CI_AS NOT NULL,
    Nickname                NVARCHAR(MAX) COLLATE Chinese_Taiwan_Stroke_CI_AS NOT NULL,
    birthday                NVARCHAR(MAX) COLLATE Chinese_Taiwan_Stroke_CI_AS NOT NULL,
    CreatedAt               DATETIME2     NOT NULL,
    ResetCode               NVARCHAR(MAX) COLLATE Chinese_Taiwan_Stroke_CI_AS NULL,
    ResetCodeExpiration     DATETIME2     NULL,
    IsNotificationEnabled   BIT           NOT NULL DEFAULT CONVERT([bit],(0)),
    Theme                   NVARCHAR(MAX) COLLATE Chinese_Taiwan_Stroke_CI_AS NOT NULL DEFAULT N'',
    CONSTRAINT PK_Users PRIMARY KEY (UserId)
);
GO

/* =========================================================
   1. Diary 日記主表
   ========================================================= */
CREATE TABLE dbo.Diary
(
    DiaryId      BIGINT       IDENTITY(1,1) NOT NULL,
    UserId       INT          NOT NULL,           -- 修正：BIGINT → INT，對應 User.UserId INT
    TemplateType VARCHAR(20)  NOT NULL,
    PreviewText  NVARCHAR(300) NULL,
    DiaryDate    DATE         NOT NULL,
    DiaryTime    TIME(0)      NOT NULL,
    WeatherType  VARCHAR(20)  NULL,
    Visibility   VARCHAR(20)  NOT NULL CONSTRAINT DF_Diary_Visibility DEFAULT ('private'),
    Status       VARCHAR(20)  NOT NULL CONSTRAINT DF_Diary_Status     DEFAULT ('draft'),
    CreatedAt    DATETIME2    NOT NULL CONSTRAINT DF_Diary_CreatedAt   DEFAULT SYSDATETIME(),
    UpdatedAt    DATETIME2    NOT NULL CONSTRAINT DF_Diary_UpdatedAt   DEFAULT SYSDATETIME(),
    DeletedAt    DATETIME2    NULL,

    CONSTRAINT PK_Diary PRIMARY KEY (DiaryId),

    CONSTRAINT FK_Diary_User
        FOREIGN KEY (UserId) REFERENCES dbo.[User](UserId),

    CONSTRAINT CK_Diary_TemplateType
        CHECK (TemplateType IN ('normal', 'mood')),

    CONSTRAINT CK_Diary_WeatherType
        CHECK (WeatherType IS NULL OR WeatherType IN ('sunny', 'cloudy', 'rainy')),

    CONSTRAINT CK_Diary_Visibility
        CHECK (Visibility IN ('private', 'shared')),

    CONSTRAINT CK_Diary_Status
        CHECK (Status IN ('draft', 'published', 'deleted')),

    CONSTRAINT CK_Diary_DeletedAt
        CHECK (
            (Status = 'deleted' AND DeletedAt IS NOT NULL)
        OR  (Status <> 'deleted')
        )
);
GO

/* 日記列表查詢索引：依 UserId、DiaryDate、CreatedAt 排序 */
CREATE INDEX IX_Diary_User_DiaryDate_CreatedAt
ON dbo.Diary (UserId, DiaryDate DESC, CreatedAt DESC);
GO

CREATE INDEX IX_Diary_User_Status
ON dbo.Diary (UserId, Status);
GO

CREATE INDEX IX_Diary_User_Visibility
ON dbo.Diary (UserId, Visibility);
GO

/* =========================================================
   2. DiaryNormal 一般日記內容（一對一延伸表）
   ========================================================= */
CREATE TABLE dbo.DiaryNormal
(
    DiaryId BIGINT        NOT NULL,
    Title   NVARCHAR(200) NULL,
    Body    NVARCHAR(MAX) NULL,

    CONSTRAINT PK_DiaryNormal PRIMARY KEY (DiaryId),

    CONSTRAINT FK_DiaryNormal_Diary
        FOREIGN KEY (DiaryId) REFERENCES dbo.Diary(DiaryId)
);
GO

/* =========================================================
   3. DiaryMood 心情日記內容（一對一延伸表）
   ========================================================= */
CREATE TABLE dbo.DiaryMood
(
    DiaryId     BIGINT        NOT NULL,
    EnergyValue TINYINT       NULL,
    StressValue TINYINT       NULL,
    SleepValue  TINYINT       NULL,
    EventNote   NVARCHAR(500) NULL,
    ThoughtNote NVARCHAR(500) NULL,
    NeedNote    NVARCHAR(500) NULL,

    CONSTRAINT PK_DiaryMood PRIMARY KEY (DiaryId),

    CONSTRAINT FK_DiaryMood_Diary
        FOREIGN KEY (DiaryId) REFERENCES dbo.Diary(DiaryId),

    CONSTRAINT CK_DiaryMood_EnergyValue
        CHECK (EnergyValue IS NULL OR EnergyValue BETWEEN 0 AND 10),

    CONSTRAINT CK_DiaryMood_StressValue
        CHECK (StressValue IS NULL OR StressValue BETWEEN 0 AND 10),

    CONSTRAINT CK_DiaryMood_SleepValue
        CHECK (SleepValue IS NULL OR SleepValue BETWEEN 0 AND 10)
);
GO

/* =========================================================
   4. Mood 情緒主表
   ========================================================= */
CREATE TABLE dbo.Mood
(
    MoodId       VARCHAR(20)  NOT NULL,
    MoodName     NVARCHAR(50) NOT NULL,
    MoodEmoji    NVARCHAR(10) NOT NULL,
    IsPositive   BIT          NOT NULL,
    IsHighEnergy BIT          NOT NULL,

    CONSTRAINT PK_Mood PRIMARY KEY (MoodId)
);
GO

/* =========================================================
   5. DiaryMoodSelection 心情日記與情緒對應（多對多）
   ========================================================= */
CREATE TABLE dbo.DiaryMoodSelection
(
    DiaryId BIGINT     NOT NULL,
    MoodId  VARCHAR(20) NOT NULL,

    CONSTRAINT PK_DiaryMoodSelection PRIMARY KEY (DiaryId, MoodId),

    CONSTRAINT FK_DiaryMoodSelection_Diary
        FOREIGN KEY (DiaryId) REFERENCES dbo.Diary(DiaryId),

    CONSTRAINT FK_DiaryMoodSelection_Mood
        FOREIGN KEY (MoodId)  REFERENCES dbo.Mood(MoodId)
);
GO

/* =========================================================
   6. Tag 標籤主表
   UserId = NULL  代表系統預設標籤
   UserId 有值    代表使用者自訂標籤
   ========================================================= */
CREATE TABLE dbo.Tag
(
    TagId     VARCHAR(20)  NOT NULL,
    UserId    INT          NULL,           -- 修正：BIGINT → INT，對應 User.UserId INT
    TagName   NVARCHAR(50) NOT NULL,
    TagType   VARCHAR(20)  NOT NULL,
    CreatedAt DATETIME2    NOT NULL CONSTRAINT DF_Tag_CreatedAt DEFAULT SYSDATETIME(),
    IsActive  BIT          NOT NULL CONSTRAINT DF_Tag_IsActive  DEFAULT (1),

    CONSTRAINT PK_Tag PRIMARY KEY (TagId),

    CONSTRAINT FK_Tag_User
        FOREIGN KEY (UserId) REFERENCES dbo.[User](UserId),

    CONSTRAINT CK_Tag_TagType
        CHECK (TagType IN ('system', 'custom')),

    CONSTRAINT CK_Tag_SystemOrCustom
        CHECK (
            (TagType = 'system' AND UserId IS NULL)
        OR  (TagType = 'custom' AND UserId IS NOT NULL)
        )
);
GO

/* 系統標籤名稱不可重複 */
CREATE UNIQUE INDEX UX_Tag_System_TagName
ON dbo.Tag (TagName)
WHERE UserId IS NULL;
GO

/* 同一使用者的自訂標籤名稱不可重複 */
CREATE UNIQUE INDEX UX_Tag_User_TagName
ON dbo.Tag (UserId, TagName)
WHERE UserId IS NOT NULL;
GO

/* =========================================================
   7. DiaryTag 日記與標籤對應（多對多）
   ========================================================= */
CREATE TABLE dbo.DiaryTag
(
    DiaryId BIGINT      NOT NULL,
    TagId   VARCHAR(20) NOT NULL,

    CONSTRAINT PK_DiaryTag PRIMARY KEY (DiaryId, TagId),

    CONSTRAINT FK_DiaryTag_Diary
        FOREIGN KEY (DiaryId) REFERENCES dbo.Diary(DiaryId),

    CONSTRAINT FK_DiaryTag_Tag
        FOREIGN KEY (TagId)   REFERENCES dbo.Tag(TagId)
);
GO

CREATE INDEX IX_DiaryTag_TagId
ON dbo.DiaryTag (TagId);
GO

/* =========================================================
   8. DiaryMedia 圖片 / 繪畫媒體
   ========================================================= */
CREATE TABLE dbo.DiaryMedia
(
    MediaId   VARCHAR(20)   NOT NULL,
    DiaryId   BIGINT        NOT NULL,
    MediaType VARCHAR(20)   NOT NULL,
    FileUrl   NVARCHAR(300) NOT NULL,
    CreatedAt DATETIME2     NOT NULL CONSTRAINT DF_DiaryMedia_CreatedAt DEFAULT SYSDATETIME(),

    CONSTRAINT PK_DiaryMedia PRIMARY KEY (MediaId),

    CONSTRAINT FK_DiaryMedia_Diary
        FOREIGN KEY (DiaryId) REFERENCES dbo.Diary(DiaryId),

    CONSTRAINT CK_DiaryMedia_MediaType
        CHECK (MediaType IN ('image', 'drawing'))
);
GO

CREATE INDEX IX_DiaryMedia_DiaryId_CreatedAt
ON dbo.DiaryMedia (DiaryId, CreatedAt ASC);
GO

/* =========================================================
   9. DiaryReaction 回應表
   同一使用者對同一篇日記僅能有一筆：UNIQUE (DiaryId, UserId)
   ========================================================= */
-- CREATE TABLE dbo.DiaryReaction
-- (
--     ReactionId   BIGINT      IDENTITY(1,1) NOT NULL,
--     DiaryId      BIGINT      NOT NULL,
--     UserId       INT         NOT NULL,      -- 修正：BIGINT → INT，對應 User.UserId INT
--     ReactionType VARCHAR(20) NOT NULL,
--     CreatedAt    DATETIME2   NOT NULL CONSTRAINT DF_DiaryReaction_CreatedAt DEFAULT SYSDATETIME(),
--     UpdatedAt    DATETIME2   NULL,

--     CONSTRAINT PK_DiaryReaction PRIMARY KEY (ReactionId),

--     CONSTRAINT FK_DiaryReaction_Diary
--         FOREIGN KEY (DiaryId) REFERENCES dbo.Diary(DiaryId),

--     CONSTRAINT FK_DiaryReaction_User
--         FOREIGN KEY (UserId)  REFERENCES dbo.[User](UserId),

--     CONSTRAINT CK_DiaryReaction_ReactionType
--         CHECK (ReactionType IN ('like', 'love', 'hug', 'empathy', 'cheer')),

--     CONSTRAINT UQ_DiaryReaction_Diary_User
--         UNIQUE (DiaryId, UserId)
-- );
-- GO

-- CREATE INDEX IX_DiaryReaction_DiaryId
-- ON dbo.DiaryReaction (DiaryId);
-- GO
