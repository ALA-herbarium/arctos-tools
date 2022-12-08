-- Duplicate entries for single specimen, by ALAAC

SELECT * FROM (
  SELECT 
    REGEXP_REPLACE(othercatalognumbers, '^.*ALAAC=([ABLV]?[0-9]+).*$', '\1')
      AS alaac,
    COUNT(*) as n
  FROM flat
  WHERE guid ~ 'UAMb?:(Alg|Herb)'
  GROUP BY alaac
) AS A
WHERE A.n > 1
ORDER BY A.alaac ;
