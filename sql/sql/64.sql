-- Barcodes, which are herbarium sheets w/o contents but with parents (= error)

SELECT grandparent.barcode AS gpbc,
  grandparent.container_type AS gptype,
  parent.barcode AS bc
FROM container AS parent
LEFT JOIN container AS child
ON child.parent_container_id = parent.container_id
LEFT JOIN container AS grandparent
ON parent.parent_container_id = grandparent.container_id
WHERE parent.container_type = 'herbarium sheet' 
AND parent.institution_acronym = 'UAM'
AND child.container_id IS NULL
AND grandparent.container_id IS NOT NULL
ORDER BY bc
LIMIT 1000

