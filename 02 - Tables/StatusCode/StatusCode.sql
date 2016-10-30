USE RServicesDemo
GO

IF OBJECT_ID('dbo.StatusCode') IS NOT NULL 
    DROP TABLE dbo.StatusCode

CREATE TABLE dbo.StatusCode (
    StatusCodeID                    TINYINT             NOT NULL,
    StatusCode                      VARCHAR(150)        NOT NULL,
    CreatedDate                     DATETIME2           NOT NULL,
    ModifiedDate                    DATETIME2               NULL
)

GO
