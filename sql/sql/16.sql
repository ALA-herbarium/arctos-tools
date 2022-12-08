-- Specimens, query on barcode

SELECT * from flat where (partdetail::json->>0)::json->>'bc' = 'H1184831'


