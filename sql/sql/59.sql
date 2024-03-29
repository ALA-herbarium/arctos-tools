-- Attributes, list, using flat

SELECT flat.guid,
 REGEXP_REPLACE(flat.attributes, '^.*culture of origin=([^;]+);.*','\1') AS culture,
 REGEXP_REPLACE(f2.attributes, '^.*value=([^;]+);?.*','\1') AS value
FROM flat
LEFT JOIN flat AS f2
ON flat.collection_object_id = f2.collection_object_id
AND f2.attributes ~ 'value='
WHERE flat.attributes IS NOT NULL AND
  flat.guid_prefix = 'UAM:EH' AND
  flat.attributes ~ 'culture of origin'
LIMIT 100
