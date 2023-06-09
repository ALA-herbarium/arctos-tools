-- Specimens, photos but no transcribed data, return GUID and Media URL

SELECT
 flat.guid,
 media_flat.media_uri,
 CASE WHEN othercatalognumbers ~ 'ALAAC'
   THEN REGEXP_REPLACE(othercatalognumbers,
      '^.*ALAAC=([ABLV]?[0-9]+).*$', '\1')
   ELSE NULL END
 AS ALAAC,
 (partdetail::json->>0)::json->>'bc' AS barcode
FROM flat LEFT JOIN (
SELECT r.related_primary_key AS co, MAX(m.media_id) AS mi
  FROM media_relations AS r, media_flat AS m
  WHERE r.media_id = m.media_id
  AND r.media_relationship = 'shows cataloged_item'
  AND m.mime_type = 'image/jpeg'
  GROUP BY r.related_primary_key
) AS a
ON flat.collection_object_id = a.co
LEFT JOIN media_flat
ON a.mi = media_flat.media_id
WHERE guid ~ 'UAM:Herb'
  AND dec_lat IS NULL
  AND imageurl IS NOT NULL
  AND collectors = 'unknown'
  AND spec_locality = 'No specific locality recorded.'
  AND media_flat.media_uri IS NOT NULL
ORDER BY guid
LIMIT 100;

