-- Duplicate entries for single specimen, by ALAAC, showing some fields

SELECT
  A.*,
  B.alaac_arctos,
  flat.guid,
  (partdetail::json->>0)::json->>'bc' AS barcode,
  higher_geog,
  spec_locality,
  collectors,
  began_date,
  scientific_name
FROM (
  SELECT * FROM (
    SELECT
      REGEXP_REPLACE(display_value,
        '^([ABLV]?)(0*)([1-9][0-9]*)$', '\1\3') AS alaac_clean,
      COUNT(*) AS n
    FROM coll_obj_other_id_num
    WHERE other_id_type = 'ALAAC'
    GROUP BY alaac_clean
  ) AS A0
  WHERE A0.n > 1
) AS A
LEFT JOIN (
  SELECT 
    collection_object_id AS coi, 
    REGEXP_REPLACE(display_value,
      '^([ABLV]?)(0*)([1-9][0-9]*)$', '\1\3') AS alaac_clean2,
    display_value AS alaac_arctos
  FROM coll_obj_other_id_num
  WHERE other_id_type = 'ALAAC'
) AS B
ON A.alaac_clean = B.alaac_clean2
LEFT JOIN flat
ON B.coi = flat.collection_object_id
ORDER BY A.alaac_clean, length(guid), guid
;

