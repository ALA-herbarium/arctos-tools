-- Specimens, all, summary of key data elements for ALA barcode checker

SELECT guid,
  (partdetail::json->>0)::json->>'part_barcode' AS bc ,
  CASE 
    WHEN othercatalognumbers ~ 'ALAAC'
    THEN REGEXP_REPLACE(othercatalognumbers,'^.*ALAAC ([ABLV]? ?[0-9]+).*$', '\1')
    ELSE NULL 
    END
    AS alaac,
  CASE 
    WHEN collectors != 'unknown' AND collectors IS NOT NULL
    THEN 1
    ELSE NULL 
    END
    AS collinfo,
  CASE 
    WHEN spec_locality !~ 'No specific locality recorded.'
      AND spec_locality !~ 'Unknown, North America'
      AND spec_locality !~ 'unknown'
    THEN 1
    ELSE NULL 
    END
    AS locninfo,
  CASE 
    WHEN dec_lat IS NOT NULL
    THEN 1
    ELSE NULL 
    END
    AS georefinfo,
  njpg,
  ndng
FROM flat
LEFT JOIN (
  SELECT cataloged_item_id, count(*) as njpg
  FROM media_relations, media
  WHERE media.media_id = media_relations.media_id
  AND media.mime_type = 'image/jpeg'
  GROUP BY cataloged_item_id
) AS JPG  
ON JPG.cataloged_item_id = flat.collection_object_id
LEFT JOIN (
  SELECT cataloged_item_id, count(*) as ndng
  FROM media_relations, media
  WHERE media.media_id = media_relations.media_id
  AND media.mime_type = 'image/dng'
  GROUP BY cataloged_item_id
) AS DNG
ON DNG.cataloged_item_id = flat.collection_object_id
WHERE
  collection_cde = 'Herb'
  AND institution_acronym = 'UAM'
-- ORDER BY guid
-- LIMIT 100
;
