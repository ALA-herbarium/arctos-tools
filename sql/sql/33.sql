-- Duplicate entries for single specimen, by ALAAC, showing some fields

SELECT A.alaac, n, orialaac, bc, guid, spec_locality, collectors, scientific_name
FROM (
  SELECT * FROM (
    SELECT 
        REGEXP_REPLACE(othercatalognumbers,
          '^.*ALAAC=([ABLV]?)(0*)([1-9][0-9]*).*$', '\1\3') AS alaac,
      COUNT(*) as n
      FROM flat
      WHERE guid ~ 'UAMb?:(Alg|Herb)' AND
      othercatalognumbers ~ 'ALAAC'
      GROUP BY alaac
   ) AS A0
   WHERE A0.n > 1
) AS A
LEFT JOIN (
SELECT
  guid,
  (partdetail::json->>0)::json->>'bc' AS bc,
  spec_locality,
  collectors,
  scientific_name,
  REGEXP_REPLACE(othercatalognumbers,
        '^.*ALAAC=([ABLV]?)(0*)([1-9][0-9]*).*$', '\1\3') AS alaac2,
  REGEXP_REPLACE(othercatalognumbers,
        '^.*ALAAC=([ABLV]?)(0*)([1-9][0-9]*).*$', '\1\2\3') AS orialaac
  FROM flat
  WHERE guid ~ 'UAMb?:(Alg|Herb)' AND
  othercatalognumbers ~ 'ALAAC' 
  AND spec_locality ~ '^[Uu]nknown$'
) AS B
ON A.alaac = B.alaac2
ORDER BY A.alaac;

