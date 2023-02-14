-- Database name
USE [bigdata_s1200522]
GO


SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

--Variable containing database name
DECLARE @user_db VARCHAR(16) = 'bigdata_s1200522'

--Remove all foreign key and primary key constrains
WHILE(
	EXISTS(
			SELECT 1 
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
			WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'
					AND CONSTRAINT_CATALOG = @user_db
			)
		)

BEGIN
    
DECLARE @sql_alterTable_fk NVARCHAR(2000)

SELECT  TOP 1 @sql_alterTable_fk = ('ALTER TABLE ' + TABLE_SCHEMA + '.[' + TABLE_NAME + '] DROP CONSTRAINT [' + CONSTRAINT_NAME + ']')
FROM    INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE   CONSTRAINT_TYPE = 'FOREIGN KEY'
        AND CONSTRAINT_CATALOG = @user_db

EXEC (@sql_alterTable_fk)
	
END

WHILE(
	EXISTS(
			SELECT 1 
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
			WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'
					AND CONSTRAINT_CATALOG = @user_db
			)
		)

BEGIN
    

SELECT  TOP 1 @sql_alterTable_fk = ('ALTER TABLE ' + TABLE_SCHEMA + '.[' + TABLE_NAME + '] DROP CONSTRAINT [' + CONSTRAINT_NAME + ']')
FROM    INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE   CONSTRAINT_TYPE = 'PRIMARY KEY'
        AND CONSTRAINT_CATALOG = @user_db

EXEC (@sql_alterTable_fk)
	
END

GO

DROP TABLE IF EXISTS [wheelie].[dimDate]

GO

CREATE TABLE [wheelie].[dimDate]
(
    [date_id]              INT NOT NULL PRIMARY KEY,
    [date]                 DATE NOT NULL,
    [year]                 SMALLINT NOT NULL,
    [month]                TINYINT NOT NULL,
    [month_name]           NVARCHAR(50),
    [day]                  TINYINT NOT NULL,
    [day_of_the_week]      TINYINT NOT NULL,
    [day_of_the_week_name] NVARCHAR(50),
    [week_number]          TINYINT NOT NULL,
    [quarter]              INT NOT NULL
)

GO

DROP TABLE IF EXISTS [wheelie].[dim_customer]

GO

CREATE TABLE [wheelie].[dim_customer]
(
    customer_id               INT IDENTITY(1,1) PRIMARY KEY,
    customer_key			  INT NOT NULL,
    first_name                NVARCHAR(50),
    last_name                 NVARCHAR(50),
    birth_date                DATE,
    city                      NVARCHAR(50),
    country                   NVARCHAR(50),
    postal_code               NVARCHAR(10)
);

GO

DROP TABLE IF EXISTS [wheelie].[dim_staff]

GO

CREATE TABLE [wheelie].[dim_staff]
(
    staff_id               INT IDENTITY(1,1) PRIMARY KEY,
    staff_key			   INT,
    first_name             NVARCHAR(50),
    last_name              NVARCHAR(50),
    city                   NVARCHAR(50),
    country                NVARCHAR(50),
    manager_id             INT,
    hired_date             INT,
    is_employed            BIT DEFAULT 1,
    FOREIGN KEY (hired_date) REFERENCES [wheelie].[dimDate] (date_id)
);

GO

DROP TABLE IF EXISTS [wheelie].[dim_store]

GO

CREATE TABLE [wheelie].[dim_store]
(
    [store_id]             INT IDENTITY (1,1) PRIMARY KEY,
    [store_key]            INT,
    [address]              NVARCHAR(50),
    [city]                 NVARCHAR(50),
    [country]              NVARCHAR(50),
    [store_manager_id]     INT,
	--[manager_first_name] NVARCHAR(50),
	--[manager_last_name]  NVARCHAR(50),
    [store_effective_date] DATETIME,
    [store_expire_date]    DATETIME,
    [is_current]           BIT DEFAULT 1
);

GO

DROP TABLE IF EXISTS [wheelie].[dim_equipment]

GO

CREATE TABLE [wheelie].[dim_equipment]
(
    equipment_id            INT IDENTITY(1,1) PRIMARY KEY,
    equipment_key			INT NOT NULL,
    equipment_name          NVARCHAR(50) NOT NULL,
    equipment_type          NVARCHAR(50) NOT NULL,
    equipment_version       NVARCHAR(50)
);

GO

DROP TABLE IF EXISTS [wheelie].[dim_equipment_group]

GO

CREATE TABLE [wheelie].[dim_equipment_group]
(
    equipment_group_id  INT IDENTITY (1,1) PRIMARY KEY,
	equipment_group_key NVARCHAR(50)
);

GO

DROP TABLE IF EXISTS [wheelie].[dim_equipment_group_bridge]

GO

CREATE TABLE [wheelie].[dim_equipment_group_bridge]
(
    equipment_group_id INT,
    equipment_id       INT,
    FOREIGN KEY (equipment_group_id) REFERENCES [wheelie].[dim_equipment_group] (equipment_group_id),
    FOREIGN KEY (equipment_id) REFERENCES [wheelie].[dim_equipment] (equipment_id),
);

GO

DROP TABLE IF EXISTS [wheelie].[dim_car]

GO

CREATE TABLE [wheelie].[dim_car]
(
    car_id              INT IDENTITY(1,1) PRIMARY KEY,
    car_key			    INT NOT NULL,
    producer	        NVARCHAR(50),
    model               NVARCHAR(50),
    production_year     INT,
    fuel_type           NVARCHAR(15) 
);

GO

DROP TABLE IF EXISTS [wheelie].[dim_service_type]

GO

CREATE TABLE [wheelie].[dim_service_type]
(
    service_type_id INT IDENTITY(1,1) PRIMARY KEY,
    type_name       NVARCHAR(100) NOT NULL
);

GO

DROP TABLE IF EXISTS [wheelie].[fact_service]

GO

CREATE TABLE [wheelie].[fact_service]
(
    service_id               INT IDENTITY(1,1) PRIMARY KEY,
    service_key				 INT NOT NULL,
    service_type             INT NOT NULL,
    service_cost             DECIMAL(18, 4),
    car_id            		 INT NOT NULL,
    service_date             INT NOT NULL,
    FOREIGN KEY (service_type) REFERENCES [wheelie].[dim_service_type] (service_type_id),
    FOREIGN KEY (service_date) REFERENCES [wheelie].[dimDate] (date_id),
    FOREIGN KEY (car_id) REFERENCES [wheelie].[dim_car] (car_id)
);

GO

DROP TABLE IF EXISTS [wheelie].[fact_rental]

GO

CREATE TABLE [wheelie].[fact_rental]
(
    rental_id               INT IDENTITY(1,1) PRIMARY KEY,
    source_system_rental_id INT NOT NULL,
    customer_id             INT NOT NULL,
    car_id            		INT NOT NULL,
    rental_start            INT NOT NULL,
    rental_length_in_days   INT,
    payment_deadline        INT NOT NULL,
    payment_date            INT NOT NULL,
    amount                  DECIMAL(12, 2) NOT NULL,
    store_id                INT NOT NULL,
    equipment_group_id      INT,
    staff_id                INT NOT NULL,
    FOREIGN KEY (staff_id) REFERENCES [wheelie].[dim_staff] (staff_id),
    FOREIGN KEY (customer_id) REFERENCES [wheelie].[dim_customer] (customer_id),
    FOREIGN KEY (car_id) REFERENCES [wheelie].[dim_car] (car_id),
    FOREIGN KEY (store_id) REFERENCES [wheelie].[dim_store] (store_id),
    FOREIGN KEY (equipment_group_id) REFERENCES [wheelie].[dim_equipment_group] (equipment_group_id)
);

GO

DROP VIEW IF EXISTS [wheelie].[viewCalendarRentalStart]

GO

CREATE VIEW [wheelie].[viewCalendarRentalStart] AS
SELECT *
FROM [wheelie].[dimDate];

GO

DROP VIEW IF EXISTS [wheelie].[viewCalendarPaymentDeadline]

GO

CREATE VIEW [wheelie].[viewCalendarPaymentDeadline] AS
SELECT *
FROM [wheelie].[dimDate];

GO

DROP VIEW IF EXISTS [wheelie].[viewCalendarPaymentDate]

GO

CREATE VIEW [wheelie].[viewCalendarPaymentDate] AS
SELECT *
FROM [wheelie].[dimDate];

GO

DROP VIEW IF EXISTS [wheelie].[viewCalendarServiceDate]

GO

CREATE VIEW [wheelie].[viewCalendarServiceDate] AS
SELECT *
FROM [wheelie].[dimDate];

GO

DROP VIEW IF EXISTS [wheelie].[viewCalendarHireDate]

GO

CREATE VIEW [wheelie].[viewCalendarHireDate] AS
SELECT *
FROM [wheelie].[dimDate];

GO

--Populate dimDate with continuous range of dates
SET DATEFIRST 1

DECLARE @StartDate DATE = '20150101';
DECLARE @CutoffDate DATE = DATEADD(DAY, -1, DATEADD(YEAR, 10, @StartDate));
;
WITH seq(n) AS
         (SELECT 0

          UNION ALL

          SELECT n + 1
          FROM seq
          WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)),

     d(d) AS
         (SELECT DATEADD(DAY, n, @StartDate)
          FROM seq),

     src AS
         (SELECT date_id              = CAST(FORMAT(d, 'yyyyMMdd') AS INT),
                 date                 = CONVERT(DATE, d),
                 year                 = DATEPART(YEAR, d),
                 month                = DATEPART(MONTH, d),
                 month_name           = FORMAT(d, 'MMMM'),
                 day                  = DATEPART(DAY, d),
                 day_of_the_week      = DATEPART(WEEKDAY, d),
                 day_of_the_week_name = DATENAME(WEEKDAY, d),
                 week_number          = DATEPART(WEEK, d),
                 quarter              = DATEPART(QUARTER, d)
          FROM d)

INSERT
INTO [wheelie].[dimDate]
SELECT *
FROM src
OPTION (MAXRECURSION 0)

GO

DROP TABLE IF EXISTS [wheelie].[stg_inventory_equipment]

GO

CREATE TABLE [wheelie].[stg_inventory_equipment]
(
    [inventory_id]       INT NOT NULL,
    [equipment_id]       INT NOT NULL
)

GO

DROP TABLE IF EXISTS [wheelie].[tmp_rental]

GO

CREATE TABLE [wheelie].[tmp_rental]
(
    [rental_id]             INT,
    [customer_id]           INT,
    [store_id]              INT,
    [staff_id]              INT,
    [rental_date]           DATE,
    [return_date]           DATE,
    [payment_date]          DATE,
    [payment_deadline_date] DATE,
    [car_id]         		INT,
	--[equipment_group_id]	INT,
    [amount]                DECIMAL(12,2)
)

GO


DROP TABLE IF EXISTS [wheelie].[tmp_fact_service]

GO

CREATE TABLE [wheelie].[tmp_fact_service]
(
	[service_id] 		INT NOT NULL,
	[service_cost]		DECIMAL(18, 4) NOT NULL,
	[service_date_id] 	INT NOT NULL,
	[service_type] 		NVARCHAR(50) NOT NULL,
	[car_id] 			INT NOT NULL
)

GO
