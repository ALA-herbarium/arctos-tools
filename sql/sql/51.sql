-- Info, find possible table from column_name

SELECT DISTINCT table_name
FROM information_schema.columns
WHERE column_name ~ 'entered' 


