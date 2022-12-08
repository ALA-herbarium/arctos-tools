-- Specimens, broad search by park including park name and geography

SELECT guid, othercatalognumbers, began_date, dec_long, dec_lat,
  higher_geog, spec_locality, verbatim_locality  
FROM flat
WHERE
  guid ~ 'UAMb?:(Herb|Alg)' AND
  began_date > '1980-01-01' AND (
  othercatalognumbers ~ 'CAKR' OR
    -- Either in the park boundary
  POLYGON '((-163.9509113,67.7764554),(-164.1816242,67.684861),(-163.8135822,67.0550308),(-162.9511554,67.0593134),(-162.9401691,67.0849932),(-162.7314289,67.0914089),(-162.7314289,67.1661331),(-163.2203205,67.2576214),(-163.2313068,67.4205825),(-163.3686359,67.5111046),(-163.3137043,67.559382),(-163.3137043,67.7307029),(-163.170882,67.7764554),(-163.2093341,67.8055242),(-163.4015949,67.7702217),(-163.9509113,67.7764554))' @> point(dec_long,dec_lat) OR
  feature ~ 'Cape Krusenstern [Nn]ational' OR
  spec_locality ~ 'Cape Krusenstern [Nn]ational' OR
  verbatim_locality ~ 'Cape Krusenstern [Nn]ational' )
ORDER BY guid ;


