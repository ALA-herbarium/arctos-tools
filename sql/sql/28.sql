-- Specimens, total count, for time period, from Russia

SELECT COUNT(*)
FROM flat
WHERE guid ~ 'UAMb?:(Herb|Alg)' AND
  higher_geog ~ 'Russia' AND
  entereddate >= '2021-09-01' ;
