-- Specimens, within a National Park, but with no NPS Catalog code

SELECT guid, othercatalognumbers, began_date, dec_long, dec_lat,
  higher_geog, spec_locality, verbatim_locality  
FROM flat
WHERE
  guid ~ 'UAMb?:(Herb|Alg)' AND
  -- no catalog number or accession code
  othercatalognumbers !~ 'KEFJ' AND
  -- collected after 1980
  began_date > '1980-01-01' AND (
    -- Either in the park boundary
  POLYGON '((-149.804584564396,60.321036196017),(-149.790642162099,60.1941603351196),(-150.154538862036,60.1049289604224),(-150.075067168946,59.978053099525),(-150.33300161143,59.8525714788572),(-150.348338253956,59.6950223329075),(-150.695504071137,59.6950223329075),(-150.993871480281,59.4245397283569),(-150.781946965375,59.4273282088162),(-150.781946965375,59.2851157053927),(-149.836652089677,59.5904543156844),(-149.478332350659,59.6838684110704),(-149.528524998926,59.9278604512578),(-149.536890440304,60.1816121730528),(-149.804584564396,60.321036196017))' @> point(dec_long,dec_lat) OR
--  higher_geog ~ 'Kenai Fjords' OR
  feature ~ 'Kenai Fjords' OR
  spec_locality ~ 'Kenai Fjords' OR
  verbatim_locality ~ 'Kenai Fjords' )
ORDER BY guid ;
