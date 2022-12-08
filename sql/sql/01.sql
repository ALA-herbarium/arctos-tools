-- Specimen count, by Herb sub-collection

SELECT guid_prefix, COUNT(*)
FROM flat
WHERE institution_acronym = 'UAM'
  AND collection_cde = 'Herb'
GROUP BY guid_prefix
ORDER BY guid_prefix ;
