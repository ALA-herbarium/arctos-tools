-- Scientific names, in ALA, with more than 1 classification in Arctos Plants

SELECT * FROM (
  SELECT B.scientific_name, count(*) as cnt
  FROM (
    SELECT DISTINCT A.scientific_name, classification_id
    FROM (
      SELECT DISTINCT identification.scientific_name
      FROM identification
      INNER JOIN flat
      ON flat.collection_object_id = identification.collection_object_id
      WHERE flat.collection_id in (6,40,106)
    ) as A, taxon_name, taxon_term
    WHERE A.scientific_name = taxon_name.scientific_name
    AND   taxon_name.taxon_name_id=taxon_term.taxon_name_id
    AND   taxon_name.name_type = 'Linnean'
    AND   taxon_term.source = 'Arctos Plants'
  ) AS B
  GROUP BY B.scientific_name
) AS C
WHERE cnt > 1

-- 2024-02-29: as of today: 0!
