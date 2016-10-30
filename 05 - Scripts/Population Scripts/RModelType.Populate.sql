USE RServicesDemo
GO

IF OBJECT_ID('tempdb..#RModelType')     IS NOT NULL     DROP TABLE #RModelType

CREATE TABLE #RModelType (
    RModelTypeID                    INT                 NOT NULL,
    RModelType                      VARCHAR(150)        NOT NULL,
    RModelTypeDesc                  VARCHAR(250)            NULL)

INSERT INTO #RModelType 
    (RModelTypeID,  RModelType,         RModelTypeDesc)    VALUES
    (1,             'TumorDiagnosis',   'Predict Tumor as Benign or Malignant based on various factors in the TumorStatistics Table'),
    (2,             'FraudRisk',        'Predict Fraud Risk from ccFraud')


UPDATE RMT
SET RMT.RModelType      = RMTTemp.RModelType,
    RMT.RModelTypeDesc  = RMTTemp.RModelTypeDesc,
    RMT.ModifiedDate    = GETDATE()   
FROM dbo.RModelType RMT
INNER JOIN #RModelType RMTTemp      ON RMT.RModelTypeID = RMTTemp.RModelTypeID
WHERE RMT.RModelType        != RMTTemp.RModelType    OR
      RMT.RModelTypeDesc    != RMTTemp.RModelTypeDesc

INSERT INTO dbo.RModelType
    (RModelTypeID,RModelType,RModelTypeDesc,CreatedDate)
SELECT RMTTemp.RModelTypeID,RMTTemp.RModelType,RMTTemp.RModelTypeDesc,GETDATE()
FROM #RModelType RMTTemp
LEFT OUTER JOIN dbo.RModelType RMT      ON RMT.RModelTypeID = RMTTemp.RModelTypeID
WHERE RMT.RModelTypeID IS NULL


GO
