-- Localities, list, sort by most specimens, UAMb:Herb

SELECT locality_id, spec_locality, count(*)
FROM flat
where guid_prefix = 'UAMb:Herb'
GROUP BY locality_id, spec_locality
ORDER BY count(*) DESC
LIMIT 30;
