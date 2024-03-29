-- Information, count of ALAAC identifiers which occur on 2 or more records!

SELECT COUNT(*)
FROM (
  SELECT display_value
  FROM (
    SELECT display_value, COUNT(*) as cnt
    FROM coll_obj_other_id_num
    WHERE other_id_type = 'ALAAC'
    GROUP BY display_value
  ) AS A
  WHERE A.cnt > 1
) as B

-- 2024-03-19: 3313  :-(

