
SELECT 
    tc.CONSTRAINT_NAME, tc.TABLE_CATALOG, tc.table_schema, tc.table_name, tc.CONSTRAINT_TYPE, ccu.COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
    JOIN 
    INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu 
        ON tc.CONSTRAINT_NAME = ccu.Constraint_name
WHERE 
   -- tc.TABLE_NAME = 'crc_credite' 
   tc.TABLE_CATALOG = 'Tests' 
   AND 
   tc.TABLE_SCHEMA = 'crc'
   AND 
   tc.CONSTRAINT_TYPE = 'Primary Key'
