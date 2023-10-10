CREATE PROC Find_Differences_Between_Tables @source_database_name VARCHAR(100), @source_schema_name VARCHAR(100),
@source_table_name VARCHAR(200), @target_database_name VARCHAR(100), @target_schema_name VARCHAR(100), @target_table_name VARCHAR(200)

AS 
BEGIN

CREATE TABLE #TempResult (ColumnName NVARCHAR(MAX), IsNullable NVARCHAR(10), DataType NVARCHAR(50), ColumnsLength INT);

-- Declare variables
DECLARE @Sql NVARCHAR(MAX);

-- Your dynamic SQL query
SET @Sql = '
	 SELECT COLUMN_NAME, is_nullable, data_type, character_maximum_length
	 FROM ' + @target_database_name + '.INFORMATION_SCHEMA.COLUMNS
	 WHERE TABLE_NAME = ' + CHAR(39) + @target_table_name + CHAR(39) +' and TABLE_SCHEMA = ' + CHAR(39) + @target_schema_name + CHAR(39) +
	 ' EXCEPT
	 SELECT COLUMN_NAME, is_nullable, data_type, character_maximum_length
	 FROM ' + @source_database_name + '.INFORMATION_SCHEMA.COLUMNS
	 WHERE TABLE_NAME = ' + CHAR(39) + @source_table_name  + CHAR(39) + ' and TABLE_SCHEMA =' + CHAR(39) + @source_schema_name + CHAR(39) + '';

-- Insert the results into the temporary table
EXEC sp_executesql @Sql;
INSERT INTO #TempResult (ColumnName, IsNullable, DataType, ColumnsLength);

-- Retrieve records from the temporary table (these records are the differences between the 2 tables)
SELECT * FROM #TempResult;

-- Delete the temporary table
DROP TABLE #TempResult;

end;