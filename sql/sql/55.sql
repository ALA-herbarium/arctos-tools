-- Specimens, having more than one ALAAC identifier

SELECT guid
  FROM (
    SELECT collection_object_id, COUNT(*) as cnt
    FROM coll_obj_other_id_num
    WHERE other_id_type = 'ALAAC'
    GROUP BY collection_object_id
  ) AS A
LEFT JOIN flat
  ON A.collection_object_id = flat.collection_object_id
WHERE A.cnt > 1 ;

-- 2024-03-19 only 6:

-- UAM:Herb:69917
-- UAM:Herb:54262
-- UAMb:Herb:47392
-- UAM:Herb:43009
-- UAM:Herb:75647
-- UAM:Herb:255538
