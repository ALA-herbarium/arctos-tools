-- Arctos Reporter, uam_myco_packet_label_2024, 2024-10-18

-- <cfquery name="d" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey,'AES/CBC/PKCS5Padding','hex')#">
SELECT
  CONCAT_WS('',
  -- single label
  '<div class="cell">',
  -- title  
  '<div class="title">Fungi of Alaska</div>',
  -- family (ALL)
  '<div class="fam">',
  UPPER(flat.family),
  '</div>',
  -- scientific_name (ALL)
  '<div class="name">',
  CASE 
    -- infraspecific
    WHEN flat.scientific_name ~ ' (var|subsp|forma)\. ' THEN
      REGEXP_REPLACE(flat.scientific_name, '^([^ ]+) +([^ ]+) +([^ ]+) +([^ ]+)( +.+)?$', '<i>\1 \2</i> \3 <i>\4</i>\5')
    -- just A single word (genus or higher)
    WHEN flat.scientific_name ~ '^[^ ]+ +[A-Z(]' THEN
      REGEXP_REPLACE(flat.scientific_name, '^([^ ]+) +(.*)$', '<i>\1</i> \2')
    -- usual case of Genus species
    ELSE
      REGEXP_REPLACE(flat.scientific_name, '^([^ ]+) +([^ ]+)( +.+)?$', '<i>\1 \2</i>\3') 
  END,
  '</div>',
  -- det by info (OPT)
  CASE 
    WHEN flat.identifiedby IS NOT NULL AND flat.identifiedby != 'unknown'
      THEN CONCAT_WS(' ',   '<div class="det">', 'Det. ', flat.identifiedby,
        ( CASE WHEN flat.made_date IS NOT NULL THEN
          CONCAT_WS(' ', 'on', flat.made_date) ELSE NULL END
        ),
        ( CASE WHEN flat.identification_remarks IS NOT NULL THEN
          CONCAT_WS('', '(Det. notes: ', flat.identification_remarks,')')
          ELSE NULL END
        ), '</div>')
    ELSE NULL END ,
  '<hr/>',
  -- description (OPT)
  CASE WHEN (flat.attributedetail::json->>0)::json->>'attribute_type' = 'description' AND
            (flat.attributedetail::json->>0)::json->>'attribute_value' IS NOT NULL THEN
    CONCAT_WS('',  '<div class="desc">Notes/description: ', 
      (flat.attributedetail::json->>0)::json->>'attribute_value' , '</div>' )
    ELSE NULL END ,
  -- locality block
  '<div class="locn">',
  -- spec_locality (ALL)
  'Location: ', flat.higher_geog, ': ', flat.spec_locality,
  -- coords (OPT)
  CASE WHEN flat.dec_lat IS NOT NULL THEN
    CONCAT_WS('', '<div class="coord">', 
      ROUND(flat.dec_lat::numeric, 4), '° lat., ',
      ROUND(flat.dec_long::numeric, 4), '° long.',
      CASE WHEN flat.coordinateuncertaintyinmeters IS NOT NULL THEN
        CONCAT_WS('', ' (error ', flat.coordinateuncertaintyinmeters, 'm)')
        ELSE NULL END,
      CASE WHEN flat.datum IS NOT NULL AND flat.datum != 'unknown' THEN
        CONCAT_WS('', '; datum: ', REGEXP_REPLACE(flat.datum, 'World Geodetic System 1984', 'WGS 84'))
      ELSE NULL END,
      '</div>')
  ELSE NULL END,
  -- elev (OPT)
  CASE WHEN flat.min_elev_in_m IS NOT NULL THEN
    CONCAT_WS('', ' Elevation: ',
      CASE WHEN flat.min_elev_in_m::varchar != flat.max_elev_in_m::varchar THEN
        CONCAT_WS('', flat.min_elev_in_m, '-', flat.max_elev_in_m)
        ELSE flat.min_elev_in_m::varchar END
        , 'm') ELSE NULL END
  ,
  '</div>',
  -- collectors (Almost all)
  '<div class="collector">Collected by: ',
  flat.collectors,
  CASE WHEN flat.collectornumber IS NOT NULL THEN
    CONCAT_WS('',' (coll. no. ', REGEXP_REPLACE(flat.collectornumber,'(.* )?([^ ]+)$','\2'), ')')
    ELSE '' END
  ,
  ' on ',
  CASE WHEN flat.began_date != flat.ended_date THEN
    CONCAT_WS('', flat.began_date, ' to ', flat.ended_date)
    ELSE flat.began_date END , 
  '</div>',
  -- identifiers, GUID (ALL) and ALAAC (should be ALL)
  '<hr/>',
  '<div class="ids"><span class="aleft">Arctos: ', flat.guid, '</span>',
  CASE WHEN othercatalognumbers ~ 'ALAAC' THEN
    CONCAT_WS('', '<span class="aright">ALAAC: ',
      REGEXP_REPLACE(othercatalognumbers,
      '^.*ALAAC ([ABLV]? ?[0-9]+).*$', '\1'),'</span>') 
  ELSE NULL END ,
  '</div>',
  -- close class="cell"
  '</div>'

) AS onelabel
FROM
  flat
INNER JOIN #table_name#
  ON flat.collection_object_id=#table_name#.collection_object_id
ORDER BY flat.guid
-- </cfquery>
-- <cfif debug is true>
--   <cfdump var=#d#>
-- </cfif>
-- <div class="wrapper">
--   <cfloop query="d">
--         #onelabel#
--   </cfloop>
-- </div>

-- .wrapper {
--     display: grid;
--     grid-template-columns: repeat(1, 1fr);
-- }
-- .cell {
--     padding: 0.25in;
--     width: 100%;  
--     height: 100%;
--     // border: 0.5px black dashed;
--     page-break-inside: avoid;
--     font-family: "Arial", Sans-serif;
--     font-size: 0.7em;
-- }
-- .title { text-align: center; margin-bottom: 0.2in; font-weight: bold; 
--   // font-style: italic;
-- }
-- .fam {
--     font-weight: bold;
-- }
-- .sn {
--     margin-top: 0.1in;
-- }
-- .det { 
--     margin-top: 0.1in; font-size: 85% 
-- }
-- // not working in builtin CSS engine
-- // .ids {  font-size: 85% ; display: flex; }
-- // .spacer { flex-grow: 1; }
-- .ids {
--     margin-top: 0.1in;
--     font-size: 85% ;
--     width: 96% ; // fudge
-- }
-- .aleft {
--     float: left ;
-- }
-- .aright {
--     float: right ;
-- }
-- hr {
--     height: 0px;
--     border: none;
--     border-top: 1px solid black;
-- }
-- .collector { 
--     margin-top: 0.1in; width: 90% ;
-- }
-- .locn {
--     margin-top: 0.1in;
-- }
-- .desc {
--     // border-top: 1px solid black;
--     margin-top: 0.1in;
--     // padding-top: 0.1in;
--     font-size: 85% ;
-- }

-- PDF: portrait, letter, top=7.25in, bottom=0.1in, left=1.5in, right=1.75
