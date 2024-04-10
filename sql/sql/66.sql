-- Containers, major, in Rooms 003, 018, 040

SELECT R.barcode AS r_bc, R.label AS r_label,
  C.barcode AS c_bc, C.container_type AS c_type, C.label AS c_label
FROM (
  SELECT container_id, barcode, container_type, label, description
  FROM container
  WHERE container_id in (23779097, 23779096, 21981632)
) AS R
LEFT JOIN (
  SELECT parent_container_id, barcode, container_type, label, description
  FROM container
  WHERE container_type NOT IN ('herbarium sheet', 'herbarium folder','tag')
) AS C
ON R.container_id = C.parent_container_id
ORDER BY r_label, c_type, c_label
