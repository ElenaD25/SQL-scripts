---used for CRC module at first

create proc InsertArrayOfJsons @json nvarchar(max), @ref_date date
as
begin 
	declare @ErrorMessage nvarchar(max), @ErrorSeverity nvarchar(max) ,@ErrorState nvarchar(max);

		begin try 
			if ISJSON(@json) !=1 
				throw 50010, 'The JSON is not formated properly', 1
			else
				INSERT INTO NAV_USERS (
				Date_created,
				Created_by,
				Date_modified,
				Modified_by,
				Line_status,
				User_code,
				User_name,
				User_desc,
				User_type,
				Memo,
				First_name,
				Last_name,
				Password,
				Provider_id,
				Email,
				User_id
				--,role_id
				)
				SELECT
					@ref_date,
					'admin@bind.local',
					@ref_date,
					NULL,
					'VALID',
					jsonValue.User_name as User_code,
					jsonValue.User_name as User_desc,
					jsonValue.User_name as User_type,
					NULL,
					'',
					jsonValue.First_name,
					jsonValue.Last_name,
					jsonValue.Password,
					0,
					jsonValue.Email,
					jsonValue.User_id
					--,CASE
					--	WHEN jsonValue.ROLE_ID ='FINREP' THEN 10
					--	WHEN jsonValue.ROLE_ID ='CRC' THEN 13
					--END AS role_id
					FROM OPENJSON(@JSON)
				WITH (
				Date_created NVARCHAR(200),
				Created_by NVARCHAR(200),
				Date_modified NVARCHAR(200),
				Modified_by NVARCHAR(200),
				Line_status NVARCHAR(200),
				User_code NVARCHAR(200),
				User_name NVARCHAR(200),
				User_desc NVARCHAR(200),
				User_type NVARCHAR(200),
				Memo NVARCHAR(200),
				First_name NVARCHAR(200),
				Last_name NVARCHAR(200),
				Password NVARCHAR(200),
				Provider_id NVARCHAR(200),
				Email NVARCHAR(200),
				User_id nvarchar(10)
				--,ROLE_ID nvarchar(10)
				) AS jsonValue;


				INSERT INTO NAV_ROLE_USERS (
				Date_created,
				Created_by,
				Date_modified,
				Modified_by,
				Line_status,
				Role_user_id,
				Role_id,
				User_id,
				Memo
				)
				SELECT
					@ref_date,
					'admin@bind.local',
					@ref_date,
					NULL,
					'VALID',
					jsonValue.User_id,
					CASE
						WHEN jsonValue.ROLE_ID ='FINREP' THEN 10
						WHEN jsonValue.ROLE_ID ='CRC' THEN 13
					END AS role_id,
					User_id,
					''
					FROM OPENJSON(@JSON)
				WITH (
				Date_created NVARCHAR(200),
				Created_by NVARCHAR(200),
				Date_modified NVARCHAR(200),
				Modified_by NVARCHAR(200),
				Line_status NVARCHAR(200),
				User_id NVARCHAR(200),
				ROLE_ID NVARCHAR(10)
				) AS jsonValue;
		end try
	begin catch
			 SELECT 
					@ErrorMessage = ERROR_MESSAGE(), 
					@ErrorSeverity = ERROR_SEVERITY(), 
					@ErrorState = ERROR_STATE();

		   RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
	end catch
end;
