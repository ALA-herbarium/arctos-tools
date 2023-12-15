-- Specimens, list bryophytes with photos, but needing transcription

SELECT
  CONCAT_WS('','=HYPERLINK("https://arctos.database.museum/guid/',guid,'","',
    guid,'")'),
  (partdetail::json->>0)::json->>'part_barcode' AS bc,
  CASE WHEN othercatalognumbers ~ 'ALAAC'
    THEN REGEXP_REPLACE(othercatalognumbers,'^.*ALAAC ([ABLV]? ?[0-9]+).*$',
      '\1')
    ELSE NULL END
  AS alaac,
  CASE WHEN (identifiedby IS NULL OR identifiedby ~ 'unknown' OR
      made_date IS NULL OR made_date = '1800-01-01')
    THEN 'missing'
    ELSE 'ok' END
  AS detinfo,
  CASE WHEN (began_date IS NULL OR began_date = '1800-01-01' OR 
    collectors ~ 'unknown' OR collectors IS NULL)
    THEN 'missing'
    ELSE 'ok' END
  AS collinfo,
  CASE WHEN (spec_locality ~ 'No specific locality recorded.' OR
      spec_locality ~ 'Unknown, North America' OR 
      spec_locality ~ '^unknown')
    THEN 'missing'
    ELSE 'ok' END
  AS locninfo,
  CASE WHEN dec_lat IS NULL
    THEN 'missing'
    ELSE 'ok' END
  AS georef
FROM flat
WHERE
  (phylum = 'Bryophyta' OR
   family IN
('Amblystegiaceae', 'Ambuchananiaceae', 'Andreaeaceae',
'Andreaeobryaceae', 'Anomodontaceae', 'Aongstroemiaceae',
'Archidiaceae', 'Aulacomniaceae', 'Bartramiaceae', 'Brachytheciaceae',
'Braithwaiteaceae', 'Bruchiaceae', 'Bryaceae', 'Bryobartramiaceae',
'Bryoxiphiaceae', 'Buxbaumiaceae', 'Callicladiaceae',
'Calliergonaceae', 'Calymperaceae', 'Catagoniaceae', 'Catoscopiaceae',
'Climaciaceae', 'Cryphaeaceae', 'Daltoniaceae', 'Dicranaceae',
'Dicranellopsidaceae', 'Diphysciaceae', 'Disceliaceae',
'Ditrichaceae', 'Drummondiaceae', 'Echinodiaceae', 'Encalyptaceae',
'Entodontaceae', 'Erpodiaceae', 'Eustichiaceae', 'Fabroniaceae',
'Fissidentaceae', 'Flatbergiaceae', 'Flexitrichaceae',
'Fontinalaceae', 'Funariaceae', 'Gigaspermaceae', 'Grimmiaceae',
'Hedwigiaceae', 'Helicophyllaceae', 'Helodiaceae', 'Hookeriaceae',
'Hylocomiaceae', 'Hypnaceae', 'Hypnodendraceae', 'Hypodontiaceae',
'Hypopterygiaceae', 'Jocheniaceae', 'Lembophyllaceae',
'Leptodontaceae', 'Leptostomataceae', 'Lepyrodontaceae', 'Leskeaceae',
'Leucobryaceae', 'Leucodontaceae', 'Leucomiaceae', 'Meesiaceae',
'Meteoriaceae', 'Micromitriaceae', 'Mitteniaceae', 'Miyabeaceae',
'Mniaceae', 'Myriniaceae', 'Myuriaceae', 'Neckeraceae',
'Oedipodiaceae', 'Orthodontiaceae', 'Orthorrhynchiaceae',
'Orthostichellaceae', 'Orthotrichaceae', 'Phyllodrepaniaceae',
'Phyllogoniaceae', 'Pilotrichaceae', 'Plagiotheciaceae',
'Pleurophascaceae', 'Pleuroziopsidaceae', 'Polytrichaceae',
'Pottiaceae', 'Prionodontaceae', 'Pseudoditrichaceae',
'Pterigynandraceae', 'Pterobryaceae', 'Pterobryellaceae',
'Ptychomitriaceae', 'Ptychomniaceae', 'Pulchrinodaceae',
'Pylaisiaceae', 'Pylaisiadelphaceae', 'Racopilaceae',
'Regmatodontaceae', 'Rhabdoweisiaceae', 'Rhachitheciaceae',
'Rhacocarpaceae', 'Rhizogemmaceae', 'Rhizogoniaceae', 'Rhytidiaceae',
'Rigodiaceae', 'Roellobryaceae', 'Ruficaulaceae', 'Rutenbergiaceae',
'Saelaniaceae', 'Saulomataceae', 'Schimperobryaceae',
'Schistostegaceae', 'Scorpidiaceae', 'Scouleriaceae', 'Seligeriaceae',
'Sematophyllaceae', 'Serpotortellaceae', 'Sphagnaceae',
'Splachnaceae', 'Stereodontaceae', 'Stereophyllaceae',
'Symphyodontaceae', 'Takakiaceae', 'Taxiphyllaceae', 'Tetraphidaceae',
'Theliaceae', 'Thuidiaceae', 'Timmiaceae', 'Trachylomataceae')) AND
  guid ~ 'UAMb:Herb' AND
  imageurl IS NOT NULL AND (
    -- det: all records have an ID, none is just 'unknown'
    -- det by and date
    ( identifiedby IS NULL OR identifiedby ~ 'unknown' OR
      made_date IS NULL OR made_date = '1800-01-01' ) AND -- switch to OR
    -- collectors and date
    ( began_date IS NULL OR began_date = '1800-01-01' OR 
      collectors ~ 'unknown' OR collectors IS NULL ) AND -- switch to OR
    -- locality
    ( spec_locality ~ 'No specific locality recorded.' OR
      spec_locality ~ 'Unknown, North America' OR 
      spec_locality ~ '^unknown' ) AND -- switch to OR
    -- georef
    ( dec_lat IS NULL) )
ORDER BY guid
LIMIT 500




