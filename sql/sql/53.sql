-- Specimens, return identifiers searching on NPS cat num (NPS project)

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
-- Lead key: NPS catalog
FROM coll_obj_other_id_num AS N
-- flat
LEFT JOIN flat
ON N.collection_object_id = flat.collection_object_id
-- ALAAC (unique per record)
LEFT JOIN coll_obj_other_id_num AS A
ON N.collection_object_id = A.collection_object_id
  AND A.other_id_type = 'ALAAC'
-- Collector number (select one only)
LEFT JOIN (
  SELECT DISTINCT ON (collection_object_id, other_id_type)
    collection_object_id, other_id_type, display_value
  FROM coll_obj_other_id_num ) AS CN
ON N.collection_object_id = CN.collection_object_id
  AND CN.other_id_type = 'collector number'
--Field number (select one only)
LEFT JOIN (
  SELECT DISTINCT ON (collection_object_id, other_id_type)
    collection_object_id, other_id_type, display_value
  FROM coll_obj_other_id_num ) AS FN
ON N.collection_object_id = FN.collection_object_id
  AND FN.other_id_type = 'field number'
--identifier (select one only)
LEFT JOIN (
  SELECT DISTINCT ON (collection_object_id, other_id_type)
    collection_object_id, other_id_type, display_value
  FROM coll_obj_other_id_num ) AS ID
ON N.collection_object_id = ID.collection_object_id
  AND ID.other_id_type = 'identifier'
-- Collector 1
LEFT JOIN collector AS COL1
ON N.collection_object_id = COL1.collection_object_id AND COL1.coll_order = 1
LEFT JOIN agent_attribute AS COL1L
ON COL1.agent_id = COL1L.agent_id AND COL1L.attribute_type = 'last name'
LEFT JOIN agent_attribute AS COL1F
ON COL1.agent_id = COL1F.agent_id AND COL1F.attribute_type = 'first name'
-- Main WHERE
WHERE N.other_id_type = 'U. S. National Park Service catalog'
AND
REGEXP_REPLACE(N.display_value, ' +','')
  IN ('KATM35953', 'KATM35954', 'KATM35955')
ORDER BY guid ;
