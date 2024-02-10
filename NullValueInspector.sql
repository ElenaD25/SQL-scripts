create proc NullValueInspector @table varchar(255)
as
begin
declare @sql_stmt nvarchar(max)

set @sql_stmt = '
				declare @col varchar(255), @cmd nvarchar(max), @counts int;
				declare @columns table (columnname varchar(255), nullcount int) ---- table variable to store column names

				declare getinfo cursor for
				select c.name from sys.tables t join sys.columns c on t.object_id = c.object_id
				where t.name = '+ char(39) + @table + char(39) + ';

				OPEN getinfo;

				FETCH NEXT FROM getinfo INTO @col;

				WHILE @@FETCH_STATUS = 0
				BEGIN
					select @cmd = ''SELECT @countsOUT = COUNT(*) FROM ' + @table + ' where ['' + @col + ''] is null'';

					exec sp_executesql @cmd, N''@countsOUT INT OUTPUT'', @counts output;

					IF @counts > 0
						INSERT INTO @columns (columnname, nullcount) VALUES (@col, @counts);

				FETCH NEXT FROM getinfo INTO @col;

				END

				CLOSE getinfo;
				DEALLOCATE getinfo;

				select columnname as colms, nullcount as no_of_nulls from @columns;'

exec sp_executesql @sql_stmt;

end