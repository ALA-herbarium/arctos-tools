-- Specimens, for list of GUIDs, show barcodes

SELECT guid, (partdetail::json->>0)::json->>'bc' AS bc 
FROM flat 
WHERE guid IN ('UAM:Herb:243406', 'UAM:Herb:244304', 'UAM:Herb:141482')
ORDER BY guid ;
