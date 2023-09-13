-- Containers

SELECT institution_acronym, container_type, COUNT(*)
FROM container
WHERE barcode ~ '^H1'
GROUP BY institution_acronym, container_type
ORDER BY COUNT(*) DESC
