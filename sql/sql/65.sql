-- Cabinets, ALA, in Room 009, by Range

SELECT R.barcode AS r_bc, R.container_type AS r_type, R.label AS r_label,
  R.description AS r_desc, 
  C.barcode AS c_bc, C.container_type AS c_type, C.label AS c_label
FROM (
  SELECT container_id, barcode, container_type, label, description
  FROM container
  WHERE parent_container_id = 11775275 
) AS R
LEFT JOIN (
  SELECT parent_container_id, barcode, container_type, label, description
  FROM container
) AS C
ON R.container_id = C.parent_container_id
WHERE R.label ~ '\(ALA\)'
ORDER BY R.label, C.label
