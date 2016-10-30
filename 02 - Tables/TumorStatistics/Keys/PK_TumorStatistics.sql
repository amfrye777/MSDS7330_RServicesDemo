USE RServicesDemo
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = object_id('dbo.TumorStatistics') and [name] = 'PK_TumorStatistics')
    ALTER TABLE dbo.TumorStatistics DROP CONSTRAINT PK_TumorStatistics 
GO

ALTER TABLE dbo.TumorStatistics ADD CONSTRAINT PK_TumorStatistics PRIMARY KEY CLUSTERED
(
    ID
) WITH (FILLFACTOR = 80) ON [Primary]
GO
