CREATE PROCEDURE Generate_Merge_Script
@target_db_name VARCHAR(100),
@source_db_name VARCHAR(100),
@target_schema_name VARCHAR(100),
@source_schema_name VARCHAR(100),
@table_name VARCHAR(100),
@join_source_col VARCHAR(100),
@join_target_col VARCHAR(100)
AS 
BEGIN
	DECLARE @columns VARCHAR(max),@qry VARCHAR(max)

SELECT @columns = stuff((SELECT ',' + c.COLUMN_NAME 
                        FROM  
						(
							SELECT COLUMN_NAME
							FROM Tests.INFORMATION_SCHEMA.COLUMNS
							WHERE TABLE_NAME = 'crc_grupuri' AND TABLE_SCHEMA = 'crc'
							INTERSECT
							SELECT COLUMN_NAME
							FROM BIND_CRC.INFORMATION_SCHEMA.COLUMNS
							WHERE TABLE_NAME = 'crc_grupuri' AND TABLE_SCHEMA = 'crc'
						) AS c
                        ORDER BY COLUMN_NAME 
                        FOR XML PATH('')), 1, 1, '')

SET @qry = N'SET IDENTITY_INSERT ' + @target_db_name + '.' + @target_schema_name + '.' + @table_name  + ' ON ;
						MERGE ' + @target_db_name +'.' + @target_schema_name +'.' + @table_name + ' AS TargetTbl USING ' 
						+ @source_db_name +'.' + @source_schema_name +'.' + @table_name + ' AS SourceTbl ON TargetTbl.' + @join_target_col+ ' = SourceTbl.' + @join_source_col
						+ ' WHEN NOT MATCHED BY target THEN'
						+ ' INSERT (' + @columns + ') VALUES'
						+ ' (' + @columns + '); SET IDENTITY_INSERT ' + @target_db_name + '.' + @target_schema_name + '.' + @table_name  + ' OFF;'

	
	--exec (@qry)
	PRINT @columns
	PRINT ''
	PRINT @qry

END