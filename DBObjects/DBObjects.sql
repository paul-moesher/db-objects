--drop database DBObjects

--create database DBObjects

use DBObjects

drop table Employees

-- creating table

CREATE TABLE Employees(
Id NVARCHAR(40) PRIMARY KEY default NEWID(),
BadgeNum INT NOT NULL UNIQUE,
SNN INT NOT NULL,
Title VARCHAR(20) NULL,
DATEHired DateTime2 Not NULL default getdate()
)

-- the trigger, on every insert it will update the title 
drop trigger empTrigger

CREATE TRIGGER empTrigger
 ON dbo.employees
    AFTER INSERT
	AS
	BEGIN
	DECLARE @Title VARCHAR(20);
	DECLARE @BadgeNum INT; SET @BadgeNum = (SELECT BadgeNum FROM inserted)
			IF @BadgeNum <= 300
			SET @Title = 'Clerk'
			ELSE IF @BadgeNum <= 699
			SET @Title = 'Office Employee'
			ELSE IF @BadgeNum <= 899
			SET @Title = 'Manager'
			ELSE
			SET @Title = 'Director' 

			UPDATE DBO.Employees 
			SET @Title = TITLE WHERE BadgeNum = @BadgeNum
			END

-- loop 25 to generate 25 random badge numbers

DECLARE @ID NVARCHAR(40);
DECLARE @BADGENUMBER INT;
DECLARE @cnt INT; SET @cnt = 1
DECLARE @SNN INT; SET @SNN=FLOOR(RAND()*(999999999-111111111+1)+999999999);
DECLARE @HIREDATE DATETIME2;
SELECT @HIREDATE = CONVERT(DATETIME2, GETDATE());

WHILE @cnt <=25
BEGIN 
SET @BADGENUMBER = CAST(RAND()*1000 AS INT);
SET @ID = NEWID()
INSERT Employees(ID, BadgeNum, SNN, Title) 
VALUES (@ID, @BADGENUMBER, @SNN, NULL)

SET @CNT = @CNT + 1;
END

-- adding in a cursor 
DECLARE @ID2 NVARCHAR(40);
DECLARE @BADGENUMBER2 INT;
DECLARE @SNN2 INT; 
DECLARE @HIREDATE2 DATETIME2;

DECLARE EMPCURSOR CURSOR FAST_FORWARD
FOR SELECT * FROM Employees;

OPEN EMPCURSOR;

FETCH NEXT FROM EMPCURSOR INTO @ID2, @BADGENUMBER2, @SNN2, @HIREDATE2;
WHILE @@FETCH_STATUS = 0
BEGIN 
PRINT @ID2 + ' ' + CAST(@BADGENUM AS NVARCHAR) + ' ' + CAST(@SNN2 AS VARCHAR) + ' ' + @Title2 + CAST(@DATEHIRED2 AS VARCHAR);
FETCH NEXT FROM EMPCURSOR INTO @ID2, @BADGENUM2, @SNN2, @TITLE2, @DATEHIRED2;
END

CLOSE EMPCURSOR;
DEALLOCATE EMPCURSOR;

-- using a view showing only ID, BadgeNum, and Title
CREATE VIEW EMPVIEW AS 
SELECT ID, BADGENUM, TITLE
FROM Employees
GO
SELECT * FROM EMPVIEW  
