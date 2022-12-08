-- Info, tables in ArctosDB, list all

SELECT tablename
FROM pg_catalog.pg_tables
WHERE tableowner = 'arctosprod'
  AND schemaname = 'core'
  AND tablename not like 'ct%'
  AND tablename not like 'cf_%'
  AND tablename not like 'ds_%'
  AND tablename not like 'pre_bulk_%';

-- Alternatively, thanks to: https://dataedo.com/kb/query/postgresql/
--   find-tables-with-specific-column-name

-- S E L E C T t.table_schema,
--        t.table_name
-- FROM information_schema.tables t
-- INNER JOIN information_schema.columns c ON c.table_name = t.table_name 
--                                 AND c.table_schema = t.table_schema
-- WHERE c.column_name = 'username'
--       AND t.table_schema NOT IN ('information_schema', 'pg_catalog')
--       AND t.table_type = 'BASE TABLE'
-- ORDER BY t.table_schema;
