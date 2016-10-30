USE master
GO

BEGIN TRY

    DECLARE @ServerName         VARCHAR(100)        =   'DESKTOP-HP1K4G2\MSSQL2016',
            @RootPath           VARCHAR(MAX)        =   'D:\Documents\School\SMU\2016 FALL\MSDS 7330 - DB Mgmt\Projects\Research Project - R Services\DemoProjectCode\RServicesDemo',
            @CmdStmt            VARCHAR(1000),
            @TypeLogStmt        VARCHAR(1000),
            @ErrorMessage       VARCHAR(500)

    PRINT 'Deploying 01_Manifest'
        SELECT @CmdStmt = 'SQLCMD -S"' + @ServerName + '" -E -d"master" -i"' + @RootPath + '\01 - Deployment\01_Manifest.sql' + '" -o"' + @RootPath + '\01 - Deployment\01_ManifestLog.txt' + '" -v path = "' + @RootPath + '"',
               @TypeLogStmt  = 'type "' + @RootPath + '\01 - Deployment\01_ManifestLog.txt"'   

        EXEC dbo.xp_cmdshell @CmdStmt, NO_OUTPUT
        Exec dbo.xp_cmdshell @TypeLogStmt

    PRINT 'Deploying 02_Manifest'
        SELECT @CmdStmt = 'SQLCMD -S"' + @ServerName + '" -E -d"master" -i"' + @RootPath + '\01 - Deployment\02_Manifest.sql' + '" -o"' + @RootPath + '\01 - Deployment\02_ManifestLog.txt' + '"',
               @TypeLogStmt  = 'type "' + @RootPath + '\01 - Deployment\02_ManifestLog.txt"'   

        EXEC dbo.xp_cmdshell @CmdStmt, NO_OUTPUT
        Exec dbo.xp_cmdshell @TypeLogStmt

    PRINT 'This Deployment script has completed.  Please check for errors.'

END TRY
BEGIN CATCH
    SELECT @ErrorMessage = ERROR_MESSAGE()

    RAISERROR(@ErrorMessage, 18, 1)
END CATCH

GO
