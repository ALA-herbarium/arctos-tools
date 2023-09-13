-- Identifiers, ALAAC, cases of duplicates caused by internal leading zeros

SELECT display_value, A.ori
FROM coll_obj_other_id_num
LEFT JOIN (
  SELECT
    regexp_replace(display_value,'^([VLBA]?)0+([1-9][0-9]+)','\1\2')
      AS newid,
    display_value AS ori
  FROM coll_obj_other_id_num
  WHERE other_id_type = 'ALAAC'
  AND display_value ~ '^[VLBA]0+'
) AS A
ON A.newid =  display_value
WHERE newid IS NOT NULL
ORDER BY substring(display_value,1,1), LENGTH(display_value), display_value

-- -- See distribution of ALAAC lengths:
-- SELECT len AS "ALAAC length", COUNT(*)
-- FROM (SELECT LENGTH(display_value) AS len
--   FROM coll_obj_other_id_num WHERE other_id_type = 'ALAAC') AS A
-- GROUP BY len ORDER by len

-- -- See poorly formed ALAACs (adjust regex to see more)
-- SELECT concat_ws('','|',display_value,'|') from coll_obj_other_id_num
-- WHERE other_id_type = 'ALAAC'
-- AND display_value !~ '^ *[VvLBA]? ?[0-9]+[A-C]? *$'
