-- Specimen count, no geographic information at all

SELECT COUNT(*)
FROM flat
WHERE guid ~ 'UAMb?:(Herb|Alg)' AND
  (spec_locality IS NULL OR spec_locality ~ '^([Uu]nknown|No specific)') AND
  higher_geog ~ '^(no higher|no specific)' AND
  country IS NULL ;


