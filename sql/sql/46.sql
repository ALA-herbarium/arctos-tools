-- Scientific names, without classification elements, tested via family
-- Depreciated. See 48.sql

SELECT A.scientific_name, taxon_term.term
FROM (
  SELECT DISTINCT identification.scientific_name
  FROM identification
  INNER JOIN flat
  ON flat.collection_object_id = identification.collection_object_id
  WHERE flat.collection_id in (6,40, 106)
) as A
LEFT JOIN taxon_name
ON A.scientific_name = taxon_name.scientific_name
LEFT JOIN taxon_term
ON taxon_name.taxon_name_id = taxon_term.taxon_name_id AND
   taxon_term.term_type = 'family' AND
   taxon_term.source IN ('Arctos Plants','Arctos','WoRMS (via Arctos)')
WHERE taxon_term.taxon_name_id IS NULL
order by A.scientific_name

-- 2024-02-29: 1289 names
