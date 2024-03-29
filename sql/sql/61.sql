-- Part attribute, location, list only the most recent for an object

SELECT flat.guid, P3.attribute_value AS location,
  P3.determined_date AS most_recent_date
FROM flat
LEFT JOIN specimen_part
ON flat.collection_object_id = specimen_part.derived_from_cat_item
LEFT JOIN (
  SELECT P1.collection_object_id, P1.determined_date, P1.attribute_value
  FROM specimen_part_attribute AS P1
  INNER JOIN (
    SELECT collection_object_id, MAX(determined_date) AS maxd
    -- Or report most recent date for a location string
    -- SELECT attribute_value, MAX(determined_date) AS maxd
    FROM specimen_part_attribute
    WHERE attribute_type = 'location'
    GROUP BY collection_object_id
    -- GROUP BY attribute_value
  ) AS P2
  ON P1.collection_object_id = P2.collection_object_id
  -- ON P1.attribute_value = P2.attribute_value
  AND P1.determined_date = P2.maxd
  AND P1.attribute_type = 'location'
) AS P3
ON specimen_part.collection_object_id = P3.collection_object_id
WHERE P3.collection_object_id IS NOT NULL
-- AND guid_prefix = 'UAM:EH'
-- LIMIT 100
--
-- Demo: set 4 location attributes to whole organism part:
--   UAM:Herb:108815: 2024-03-01 -> room1, 2024-03-27 -> room2 
--   UAM:Herb:108734: 2024-03-01 -> room2, 2024-03-27 -> room1
--   this code shows only ...108815 in room2 and and ...108734 in room 1
AND guid IN ('UAM:Herb:108815','UAM:Herb:108734')

