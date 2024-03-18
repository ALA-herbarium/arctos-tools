-- Specimens, return identifiers searching on ALAAC (NPS project)

SELECT
  REGEXP_REPLACE(N.display_value, ' +','') AS nps, 
  A.display_value AS alaac,
  CONCAT_WS(', ', COL1L.attribute_value, COL1F.attribute_value) AS collector,
  CASE
    WHEN CN.display_value IS NOT NULL THEN CN.display_value
    WHEN FN.display_value IS NOT NULL THEN FN.display_value
    WHEN ID.display_value IS NOT NULL THEN ID.display_value
    ELSE NULL END
  AS collector_code,
  guid
-- Lead key: ALAAC
FROM coll_obj_other_id_num AS A
-- flat
LEFT JOIN flat
ON A.collection_object_id = flat.collection_object_id
-- NPS cat
LEFT JOIN coll_obj_other_id_num AS N
ON N.collection_object_id = A.collection_object_id
  AND N.other_id_type = 'U. S. National Park Service catalog'
-- Collector number (select one only)
LEFT JOIN (
  SELECT DISTINCT ON (collection_object_id, other_id_type)
    collection_object_id, other_id_type, display_value
  FROM coll_obj_other_id_num ) AS CN
ON A.collection_object_id = CN.collection_object_id
  AND CN.other_id_type = 'collector number'
--Field number (select one only)
LEFT JOIN (
  SELECT DISTINCT ON (collection_object_id, other_id_type)
    collection_object_id, other_id_type, display_value
  FROM coll_obj_other_id_num ) AS FN
ON A.collection_object_id = FN.collection_object_id
  AND FN.other_id_type = 'field number'
--identifier (select one only)
LEFT JOIN (
  SELECT DISTINCT ON (collection_object_id, other_id_type)
    collection_object_id, other_id_type, display_value
  FROM coll_obj_other_id_num ) AS ID
ON A.collection_object_id = ID.collection_object_id
  AND ID.other_id_type = 'identifier'
-- Collector 1
LEFT JOIN collector AS COL1
ON A.collection_object_id = COL1.collection_object_id AND COL1.coll_order = 1
LEFT JOIN agent_attribute AS COL1L
ON COL1.agent_id = COL1L.agent_id AND COL1L.attribute_type = 'last name'
LEFT JOIN agent_attribute AS COL1F
ON COL1.agent_id = COL1F.agent_id AND COL1F.attribute_type = 'first name'
-- Main WHERE
WHERE A.other_id_type = 'ALAAC'
AND A.display_value IN ('V143130','V143131','V143132')
ORDER BY guid ;

