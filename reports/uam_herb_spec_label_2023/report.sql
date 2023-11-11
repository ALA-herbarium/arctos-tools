SELECT
  CONCAT_WS('',
  -- comment out following line for production:
  '<html><head><link href="report.css" rel="stylesheet"/><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body><div class="wrapper">',
  
  '<div class="cell">',
  -- family (ALL)
  '<div class="fam">',
  UPPER(flat.family),
  '</div>',
  -- scientific_name (ALL)
  '<div>',
  '<span class="sn">',
  flat.scientific_name,
  '</span>',
  -- author_text (OPT)
  CASE WHEN flat.author_text IS NOT NULL THEN
    CONCAT(' ', flat.author_text) ELSE NULL END
  ,
  '</div>',
  -- det by info (OPT)
  CASE WHEN flat.identifiedby IS NOT NULL AND flat.identifiedby != 'unknown'
    THEN CONCAT_WS(' ', '<hr/>Det. ', flat.identifiedby,
      ( CASE WHEN flat.made_date IS NOT NULL THEN
        CONCAT_WS(' ', 'on', flat.made_date) ELSE NULL END
        ),
      ( CASE WHEN flat.identification_remarks IS NOT NULL THEN
        CONCAT_WS('', '(Det. notes: ', flat.identification_remarks,')')
        ELSE NULL END
        ))
    ELSE NULL END
  ,
  -- identifiers, GUID (ALL) and ALAAC (should be ALL)
  '<hr/><div class="guid">Arctos: ',
  flat.guid,
  ' ',
  CASE WHEN othercatalognumbers ~ 'ALAAC' THEN
    CONCAT_WS(' ', 'ALAAC:',
      REGEXP_REPLACE(othercatalognumbers,
      '^.*ALAAC ([ABLV]? ?[0-9]+).*$', '\1')) ELSE NULL END
  ,
  '</div>',
  '<hr/>',
  -- collectors
  '<div>',
  flat.collectors,
  ' ',
  flat.collectornumber,
  ' (',
  CASE WHEN flat.began_date != flat.ended_date THEN
    CONCAT_WS('', flat.began_date, ' to ', flat.ended_date)
    ELSE flat.began_date END
  , 
  ')',
  '</div>',
  -- locality block
  '<div>',
  -- spec_locality (ALL)
  flat.spec_locality,
  -- coords (OPT)
  CASE WHEN flat.dec_lat IS NOT NULL THEN
    CONCAT_WS('', '. ', ROUND(flat.dec_lat::numeric, 4), '° lat., ',
      ROUND(flat.dec_long::numeric, 4), '° long.',
        CASE WHEN flat.coordinateuncertaintyinmeters IS NOT NULL THEN
          CONCAT_WS(' ', ' err.', flat.coordinateuncertaintyinmeters, 'm')
          ELSE NULL END
        )
  ELSE NULL END
  ,
  -- elev (OPT)
  CASE WHEN flat.min_elev_in_m IS NOT NULL THEN
    CONCAT_WS('', ' Elevation: ',
      CASE WHEN flat.min_elev_in_m::varchar != flat.max_elev_in_m::varchar THEN
        CONCAT_WS('', flat.min_elev_in_m, '-', flat.max_elev_in_m)
        ELSE flat.min_elev_in_m::varchar END
        , 'm') ELSE NULL END
  ,
  '</div>',
  -- close class="cell"
  '</div>'
  -- comment out following line for production:
  ,'</div></body></html>'
  )
FROM
  flat
-- INNER JOIN #table_name#
--   ON flat.collection_object_id=#table_name#.collection_object_id
-- ORDER BY flat.guid
WHERE
  guid = 'UAM:Herb:252636'
--  scientific_name = 'Claytonia arctica'


  
  -- flat.collection_object_id,
  -- flat.othercatalognumbers,
  -- taxonomy
--   UPPER(flat.family) AS fam_str,
--   flat.identifiedby,
--   flat.made_date,
--   flat.identification_remarks,
--   -- collection
--   flat.accession,
--   flat.collectors,
--   flat.field_num,
--   flat.collectornumber,
--   flat.began_date,
--   flat.ended_date,
-- -- location
--   flat.higher_geog,
--   flat.spec_locality,
--   flat.min_elev_in_m,
--   flat.max_elev_in_m,
--   ROUND(flat.dec_lat::numeric, 4) AS lat_str,
--   ROUND(flat.dec_long::numeric, 4) AS long_str,
--   flat.dec_lat,
--   flat.dec_long,
--   flat.datum,
--   flat.coordinateuncertaintyinmeters,
--   flat.habitat
