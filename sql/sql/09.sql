-- Barcode, and container, query on catalog number

SELECT '1', guid, (partdetail::json->>0)::json->>'cp' AS cp from flat where othercatalognumbers ~ 'V143001'

-- NPS
-- SELECT '2', guid, (partdetail::json->>0)::json->>'cp' AS cp from flat where othercatalognumbers ~ 'YUCH 7973'
-- By Guid
-- SELECT '3', guid, (partdetail::json->>0)::json->>'cp' AS cp from flat where guid = 'UAM:Herb:142185';
