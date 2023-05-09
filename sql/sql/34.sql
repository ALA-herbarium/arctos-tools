-- Duplicate entries for single specimen, by Barcode

SELECT * FROM (
  SELECT 
    (partdetail::json->>0)::json->>'bc' AS bc,
    COUNT(*) as n
  FROM flat
  WHERE guid ~ 'UAMb?:(Alg|Herb)'
  GROUP BY bc
) AS A
WHERE A.n > 1
ORDER BY A.bc
;
