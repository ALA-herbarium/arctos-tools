-- Specimen count, in Asia, with locality but not georeferenced

SELECT COUNT(*) FROM flat
WHERE guid ~ 'UAMb?:(Herb|Alg)' AND
  -- some locality info
  (spec_locality IS NOT NULL
   AND spec_locality !~ '^([Uu]nknown|No specific)') AND
  -- Asia, via higher geog or country
  (higher_geog ~ '(Russia|Japan|Papua|China)' OR
   country ~ '(Russia|Japan|Papua|China)') AND
  -- no long/lat
  dec_long IS NULL;
