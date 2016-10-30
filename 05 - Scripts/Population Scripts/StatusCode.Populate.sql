USE RServicesDemo
GO

IF OBJECT_ID('tempdb..#StatusCode')     IS NOT NULL     DROP TABLE #StatusCode

CREATE TABLE #StatusCode (
    StatusCodeID                    INT                 NOT NULL,
    StatusCode                      VARCHAR(150)        NOT NULL)

INSERT INTO #StatusCode 
    (StatusCodeID,  StatusCode)    VALUES
    (0,             'Active'),
    (1,             'Inactive')

UPDATE SC
SET SC.StatusCode      = SCTemp.StatusCode,
    SC.ModifiedDate    = GETDATE()   
FROM dbo.StatusCode SC
INNER JOIN #StatusCode SCTemp      ON SC.StatusCodeID = SCTemp.StatusCodeID
WHERE SC.StatusCode        != SCTemp.StatusCode

INSERT INTO dbo.StatusCode
    (StatusCodeID,StatusCode,CreatedDate)
SELECT SCTemp.StatusCodeID,SCTemp.StatusCode,GETDATE()
FROM #StatusCode SCTemp
LEFT OUTER JOIN dbo.StatusCode SC      ON SC.StatusCodeID = SCTemp.StatusCodeID
WHERE SC.StatusCodeID IS NULL


GO
