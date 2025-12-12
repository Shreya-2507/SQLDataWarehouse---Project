-- create database and schema

USE master
GO;

IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;

GO;

-- CREATE THE DATABASE 'DataWarehouse'

CREATE DATABASE DataWarehouse ;
GO;

USE DataWarehouse
GO;

-- CREATE SCHEMAS "table hi Schema hai.Actual data baad mein aata hai.Schema sirf rules batata hai."


CREATE SCHEMA bronze ;
GO

CREATE SCHEMA silver ;
GO

CREATE SCHEMA gold ;
Go
