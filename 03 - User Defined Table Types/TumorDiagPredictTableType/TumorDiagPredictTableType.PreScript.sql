USE RServicesDemo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.TumorDiag#Predict') AND type in (N'P', N'PC'))
    DROP PROCEDURE dbo.TumorDiag#Predict
GO

