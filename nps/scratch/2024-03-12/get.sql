SELECT
  -- 1 - Catalog # (direct)
  CONCAT_WS('',
      -- first four chars
      SUBSTRING(N.display_value,1,4),
      -- spaces
      REPEAT(' ', (12 - CHAR_LENGTH(REGEXP_REPLACE(N.display_value,' +','')))),
      -- numbers
      REGEXP_REPLACE(N.display_value, '[A-Z ]+',''))
  AS "Catalog #",
  -- 2 - Accession # (direct)
  C.display_value AS "Accession #",
  -- 3 - Class 1 (fixed)
  'BIOLOGY' AS "Class 1",
  -- 4 - Kingdom (direct)
  flat.kingdom AS "Kingdom",
  -- 5 - Phylum/Division (direct)
  flat.phylum AS "Phylum/Division",
  -- 6 - Class (direct)
  flat.phylclass AS "Class",
  -- 7 - Order (fixed)
  flat.phylorder AS "Order",
  -- 8 - Family (fixed)
  flat.family AS "Family",
  -- 9 - Sci. Name:Genus (split)
  flat.genus AS "Sci. Name:Genus",
  -- 10 - Sci. Name:Species (split)
  CASE WHEN flat.subspecies IS NULL
    THEN REPLACE(flat.species, CONCAT(flat.genus, ' '),'')
    ELSE REPLACE(flat.subspecies, CONCAT(flat.genus, ' '),'') END
    AS "Sci. Name:Species",
  -- 11 - Common Name (fixed)
  '' AS "Common Name",
  -- 12 - TSN (fixed)
  '' AS "TSN",
  -- 13 - Item Count (direct)
  1 AS "Item Count",
  -- 14 - Quantity (fixed)
  '' AS "Quantity",
  -- 15 - Storage Unit (fixed)
  'EA' AS "Storage Unit",
  -- 16 - Description (fixed)
  CONCAT(flat.scientific_name, '  vascular plant specimens moun') AS "Description",
  -- 17 - Dimens/Weight (fixed)
  '' AS "Dimens/Weight",
  -- 18 - Collector (transform)
  REGEXP_REPLACE(
  CONCAT_WS('; ',
    CONCAT_WS(', ', COL1L.attribute_value, COL1F.attribute_value),
    CONCAT_WS(', ', COL2L.attribute_value, COL2F.attribute_value),
    CONCAT_WS(', ', COL3L.attribute_value, COL3F.attribute_value),
    CONCAT_WS(', ', COL4L.attribute_value, COL4F.attribute_value)),'[; ]+$','')
    AS "Collector",
  -- 19 - Collection # (direct)
  CASE
    WHEN CN.display_value IS NOT NULL THEN CN.display_value
    WHEN FN.display_value IS NOT NULL THEN FN.display_value
    WHEN ID.display_value IS NOT NULL THEN ID.display_value
    ELSE NULL END
  AS "Collection #",
  -- 20 - Collection Date (transform)
  -- TO_CHAR(flat.ended_date::date, 'FMMM/FMDD/YYYY')
  flat.ended_date
  AS "Collection Date",
  -- 21 - Condition (fixed)
  'COM/GD' AS "Condition",
  -- 22 - Condition Desc (fixed)
  '' AS "Condition Desc",
  -- 23 - Study # (fixed)
  '' AS "Study #",
  -- 24 - Other Numbers (combine)
  CONCAT_WS('', 'Arctos=', guid, 
  CASE WHEN A.display_value IS NOT NULL
    THEN CONCAT_WS('', ' ALAAC=', A.display_value)
    ELSE NULL END
    ) AS "Other Numbers",
  -- 25 - Cataloger (transform)
  UPPER(CONCAT_WS(', ', CPL.attribute_value, CPF.attribute_value))
    AS "Cataloger",
  -- 26 - Catalog Date (transform)
  TO_CHAR(entereddate::date, 'FMMM/FMDD/YYYY')
    AS "Catalog Date",
  -- 27 - Identified By (direct)
  CONCAT_WS(', ', IDENTL.attribute_value, IDENTF.attribute_value)
    AS "Identified By",
  -- 28 - Ident Date (transform)
  -- TO_CHAR(flat.made_date::date, 'FMMM/FMDD/YYYY') AS "Ident Date",
  CASE
    WHEN CHAR_LENGTH(flat.made_date) = 10 THEN
      TO_CHAR(flat.made_date::date, 'FMMM/FMDD/YYYY')
    WHEN CHAR_LENGTH(flat.made_date) = 7 THEN
      CONCAT_WS('/',SUBSTRING(flat.made_date,6,2),SUBSTRING(flat.made_date,1,4))
    WHEN CHAR_LENGTH(flat.made_date) = 4 THEN
      flat.made_date
    ELSE NULL END
    AS "Ident Date",
  -- 29 - Repro Method (fixed)
  '' AS "Repro Method",
  -- 30 - Locality (direct)
  flat.verbatim_locality AS "Locality",
  -- 31 - Unit (fixed)
  '' AS "Unit",
  -- 32 - State (fixed)
  'AK' AS "State",
  -- 33 - Reference Datum (transform)
  CASE
    WHEN flat.datum = 'World Geodetic System 1984' THEN 'WGS 84'
    WHEN flat.datum = 'North American Datum 1927' THEN 'NAD 27'
    WHEN flat.datum = 'North American Datum 1983' THEN 'NAD 83'
    ELSE NULL END
  AS "Reference Datum",
  -- 34 - Watrbody/Drain:Waterbody (fixed)
  '' AS "Watrbody/Drain:Waterbody",
  -- 35 - Watrbody/Drain:Drainage (fixed)
  '' AS "Watrbody/Drain:Drainage",
  -- 36 - UTM Z/E/N (fixed)
  '' AS "UTM Z/E/N",
  -- 37 - Lat LongN/W (combine)
  CONCAT_WS('', 'N', dec_lat, '/W',  REPLACE(flat.dec_long::varchar,'-',''))
    AS "Lat LongN/W",
  -- 38 - Elevation (transform)
  CASE WHEN flat.max_elev_in_m IS NOT NULL
    THEN CONCAT_WS('', flat.max_elev_in_m, ' m')
  ELSE NULL END
  AS "Elevation",
  -- 39 - Depth (fixed)
  '' AS "Depth",
  -- 40 - Depos Environ (fixed)
  '' AS "Depos Environ",
  -- 41 - Habitat/Comm (fixed)
  '' AS "Habitat/Comm",
  -- 42 - Habitat (direct)
  flat.habitat AS "Habitat",
  -- 43 - Slope (fixed)
  '' AS "Slope",
  -- 44 - Aspect (fixed)
  '' AS "Aspect",
  -- 45 - Soil Type (fixed)
  '' AS "Soil Type",
  -- 46 - For/Per/Sub (fixed)
  '' AS "For/Per/Sub",
  -- 47 - Assoc Spec (fixed)
  '' AS "Assoc Spec",
  -- 48 - Type Specimen (fixed)
  flat.typestatus AS "Type Specimen",
  -- 49 - Threat/Endang (fixed)
  '' AS "Threat/Endang",
  -- 50 - T/E Date (fixed)
  '' AS "T/E Date",
  -- 51 - Rare (fixed)
  '' AS "Rare",
  -- 52 - Exotic/Native (fixed)
  '' AS "Exotic/Native",
  -- 53 - Age (fixed)
  '' AS "Age",
  -- 54 - Sex (fixed)
  '' AS "Sex",
  -- 55 - Notes (fixed)
  '' AS "Notes",
  -- 56 - Field Season
  -- TO_CHAR(flat.ended_date::date, 'YYYY')
  SUBSTRING(flat.ended_date,1,4)
    AS "Field Season",
  -- 57 - Ctrl Prop (fixed)
  'N' AS "Ctrl Prop",
  -- 58 - Location (fixed)
  'UAMN - ALA HERBARIUM' AS "Location",
  -- 59 - Object Status (fixed)
  'LOAN OUT – NON-NPS – NON-FEDERAL' AS "Object Status",
  -- 60 - Status Date (fixed)
  '' AS "Status Date",
  -- 61 - Catalog Folder (fixed)
  'N' AS "Catalog Folder",
  -- 62 - Maint. Cycle (fixed)
  '' AS "Maint. Cycle"
-- SELECT N.display_value AS nps, flat.guid, A.display_value AS alaac, CONCAT_WS('; ', CONCAT_WS(', ', COL1L.attribute_value, COL1F.attribute_value), CONCAT_WS('', COL2L.attribute_value, ', ', COL2F.attribute_value))

-- Lead key: NPS catalog
FROM coll_obj_other_id_num AS N

-- flat
LEFT JOIN flat
ON N.collection_object_id = flat.collection_object_id

-- Other identifiers:
-- NPS accession (unique per record)
LEFT JOIN coll_obj_other_id_num AS C
ON N.collection_object_id = C.collection_object_id
  AND C.other_id_type = 'U. S. National Park Service accession'

-- ALAAC (unique per record)
LEFT JOIN coll_obj_other_id_num AS A
ON N.collection_object_id = A.collection_object_id
  AND A.other_id_type = 'ALAAC'

-- Collector number (select one only)
LEFT JOIN (
  SELECT DISTINCT ON (collection_object_id, other_id_type)
    collection_object_id, other_id_type, display_value
  FROM coll_obj_other_id_num ) AS CN
ON N.collection_object_id = CN.collection_object_id
  AND CN.other_id_type = 'collector number'

--Field number (select one only)
LEFT JOIN (
  SELECT DISTINCT ON (collection_object_id, other_id_type)
    collection_object_id, other_id_type, display_value
  FROM coll_obj_other_id_num ) AS FN
ON N.collection_object_id = FN.collection_object_id
  AND FN.other_id_type = 'field number'

--identifier (select one only)
LEFT JOIN (
  SELECT DISTINCT ON (collection_object_id, other_id_type)
    collection_object_id, other_id_type, display_value
  FROM coll_obj_other_id_num ) AS ID
ON N.collection_object_id = ID.collection_object_id
  AND ID.other_id_type = 'identifier'

-- Collector names, via collector table
LEFT JOIN collector AS COL
ON N.collection_object_id = COL.collection_object_id
-- Collector 1
LEFT JOIN agent_attribute AS COL1L
ON COL.agent_id = COL1L.agent_id
  AND COL.coll_order = 1 AND COL1L.attribute_type = 'last name'
LEFT JOIN agent_attribute AS COL1F
ON COL.agent_id = COL1F.agent_id
  AND COL.coll_order = 1 AND COL1F.attribute_type = 'first name'
-- Collector 2
LEFT JOIN agent_attribute AS COL2L
ON COL.agent_id = COL2L.agent_id
  AND COL.coll_order = 2 AND COL2L.attribute_type = 'last name'
LEFT JOIN agent_attribute AS COL2F
ON COL.agent_id = COL2F.agent_id
  AND COL.coll_order = 2 AND COL2F.attribute_type = 'first name'
-- Collector 3
LEFT JOIN agent_attribute AS COL3L
ON COL.agent_id = COL3L.agent_id
  AND COL.coll_order = 3 AND COL3L.attribute_type = 'last name'
LEFT JOIN agent_attribute AS COL3F
ON COL.agent_id = COL3F.agent_id
  AND COL.coll_order = 3 AND COL3F.attribute_type = 'first name'
-- Collector 4
LEFT JOIN agent_attribute AS COL4L
ON COL.agent_id = COL4L.agent_id
  AND COL.coll_order = 4 AND COL4L.attribute_type = 'last name'
LEFT JOIN agent_attribute AS COL4F
ON COL.agent_id = COL4F.agent_id
  AND COL.coll_order = 4 AND COL4F.attribute_type = 'first name'

-- Entered by person, via coll_object
LEFT JOIN cataloged_item AS COLLOBJ
ON N.collection_object_id = COLLOBJ.collection_object_id
LEFT JOIN agent_attribute AS CPL
ON COLLOBJ.created_agent_id = CPL.agent_id
  AND CPL.attribute_type = 'last name'
LEFT JOIN agent_attribute AS CPF
ON COLLOBJ.created_agent_id = CPF.agent_id
  AND CPF.attribute_type = 'first name'

-- Identified by person, via identification (one only), identification agent
LEFT JOIN (
  SELECT DISTINCT ON (collection_object_id, identification_order)
    collection_object_id, identification_id
  FROM identification) AS IDENT
ON N.collection_object_id = IDENT.collection_object_id
LEFT JOIN identification_agent
ON IDENT.identification_id = identification_agent.identification_id
  AND identification_agent.identifier_order = 1
LEFT JOIN agent_attribute AS IDENTF
ON identification_agent.agent_id = IDENTF.agent_id
  AND IDENTF.attribute_type = 'first name'
LEFT JOIN agent_attribute AS IDENTL
ON identification_agent.agent_id = IDENTL.agent_id
  AND IDENTL.attribute_type = 'last name'

-- Main WHERE
WHERE N.other_id_type = 'U. S. National Park Service catalog'
AND
REGEXP_REPLACE(N.display_value, ' +','')
  IN ('KATM35953',
'KATM35954',
'KATM35955',
'KATM35956',
'KATM35957',
'KATM35958',
'KATM35959',
'KATM35960',
'KATM35961',
'KATM35962',
'KATM35963',
'KATM35964',
'KATM35965',
'KATM35966',
'KATM35967',
'KATM35968',
'KATM35969',
'KATM35970',
'KATM35972',
'KATM35973',
'KATM35974',
'KATM35975',
'KATM35976',
'KATM35977',
'KATM35978',
'KATM35979',
'KATM35980',
'KATM35981',
'KATM35982',
'KATM35983',
'KATM35984',
'KATM35985',
'KATM35986',
'KATM35987',
'KATM35988',
'KATM35989',
'KATM35990',
'KATM35991',
'KATM35992',
'KATM35993',
'KATM35994',
'KATM35995',
'KATM35996',
'KATM35997',
'KATM35998',
'KATM35999',
'KATM36000',
'KATM36001',
'KATM36002',
'KATM36003',
'KATM36004',
'KATM36005',
'KATM36006',
'KATM36007',
'KATM36008',
'KATM36009',
'KATM36010',
'KATM36011',
'KATM36012',
'KATM36013',
'KATM36014',
'KATM36015',
'KATM36016',
'KATM36017',
'KATM36018',
'KATM36019',
'KATM36020',
'KATM36021',
'KATM36022',
'KATM36023',
'KATM36024',
'KATM36025',
'KATM36026',
'KATM36027',
'KATM36028',
'KATM36029',
'KATM36030',
'KATM36031',
'KATM36032',
'KATM36033',
'KATM36034',
'KATM36035',
'KATM36036',
'KATM36037',
'KATM36038',
'KATM36039',
'KATM36040',
'KATM36041',
'KATM36042',
'KATM36043',
'KATM36044',
'KATM36045',
'KATM36046',
'KATM36047',
'KATM36048',
'KATM36049',
'KATM36050',
'KATM36051',
'KATM36052',
'KATM36053',
'KATM36054',
'KATM36055',
'KATM36056',
'KATM36057',
'KATM36058',
'KATM36059',
'KATM36060',
'KATM36061',
'KATM36062',
'KATM36063',
'KATM36064',
'KATM36065',
'KATM36066',
'KATM36067',
'KATM36068',
'KATM36069',
'KATM36070',
'KATM36071',
'KATM36072',
'KATM36073',
'KATM36074',
'KATM36075',
'KATM36076',
'KATM36077',
'KATM36078',
'KATM36079',
'KATM36080',
'KATM36081',
'KATM36082',
'KATM36083',
'KATM36084',
'KATM36085',
'KATM36086',
'KATM36087',
'KATM36088',
'KATM36089',
'KATM36090',
'KATM36091',
'KATM36092',
'KATM36093',
'KATM36094',
'KATM36095',
'KATM36096',
'KATM36097',
'KATM36098',
'KATM36099',
'KATM36100',
'KATM36101',
'KATM36102',
'KATM36103',
'KATM36104',
'KATM36105',
'KATM36106',
'KATM36107',
'KATM36108',
'KATM36109',
'KATM36110',
'KATM36111',
'KATM36112',
'KATM36113',
'KATM36114',
'KATM36115',
'KATM36116',
'KATM36117',
'KATM36118',
'KATM36119',
'KATM36120',
'KATM36121',
'KATM36122',
'KATM36123',
'KATM36124',
'KATM36125',
'KATM36126',
'KATM36127',
'KATM36128',
'KATM36129',
'KATM36130',
'KATM36131',
'KATM36132',
'KATM36133',
'KATM36134',
'KATM36135',
'KATM36136',
'KATM36137',
'KATM36138',
'KATM36139',
'KATM36140',
'KATM36141',
'KATM36142',
'KATM36143',
'KATM36144',
'KATM36145',
'KATM36146',
'KATM36147',
'KATM36148',
'KATM36149',
'KATM36150',
'KATM36151',
'KATM36152',
'KATM36153',
'KATM36154',
'KATM36155',
'KATM36156',
'KATM36157',
'KATM36158',
'KATM36159',
'KATM36160',
'KATM36161',
'KATM36162',
'KATM36163',
'KATM36164',
'KATM36165',
'KATM36166',
'KATM36167',
'KATM36168',
'KATM36169',
'KATM36170',
'KATM36171',
'KATM36172',
'KATM36173',
'KATM36174',
'KATM36175',
'KATM36176',
'KATM36177',
'KATM36178',
'KATM36179',
'KATM36180',
'KATM36181',
'KATM36182',
'KATM36183',
'KATM36184',
'KATM36185',
'KATM36186',
'KATM36187',
'KATM36188',
'KATM36189',
'KATM36190',
'KATM36191',
'KATM36192',
'KATM36193',
'KATM36194',
'KATM36195',
'KATM36196',
'KATM36197',
'KATM36198',
'KATM36199',
'KATM36200',
'KATM36201',
'KATM36202',
'KATM36203',
'KATM36204',
'KATM36205',
'KATM36206',
'KATM36207',
'KATM36208',
'KATM36209',
'KATM36210',
'KATM36211',
'KATM36212',
'KATM36213',
'KATM36214',
'KATM36215',
'KATM36216',
'KATM36217',
'KATM36218',
'KATM36219',
'KATM36220',
'KATM36221',
'KATM36222',
'KATM36223',
'KATM36224',
'KATM36225',
'KATM36226',
'KATM36227',
'KATM36228',
'KATM36229',
'KATM36230',
'KATM36231',
'KATM36232',
'KATM36233',
'KATM36234',
'KATM36235',
'KATM36236',
'KATM36237',
'KATM36238',
'KATM36239',
'KATM36240',
'KATM36241',
'KATM36242',
'KATM36243',
'KATM36244',
'KATM36245',
'KATM36246',
'KATM36247',
'KATM36248',
'KATM36249',
'KATM36250',
'KATM36251',
'KATM36252',
'KATM36253',
'KATM36254',
'KATM36255',
'KATM36256',
'KATM36257',
'KATM36258',
'KATM36259',
'KATM36260',
'KATM36261',
'KATM36262',
'KATM36263',
'KATM36264',
'KATM36265',
'KATM36266',
'KATM36267',
'KATM36268',
'KATM36269',
'KATM36270',
'KATM36271',
'KATM36272',
'KATM36273',
'KATM36274',
'KATM36275',
'KATM36276',
'KATM36277',
'KATM36278',
'KATM36279',
'KATM36280',
'KATM36281',
'KATM36282',
'KATM36283',
'KATM36284',
'KATM36285',
'KATM36286',
'KATM36287',
'KATM36288',
'KATM36289',
'KATM36290',
'KATM36291',
'KATM36292',
'KATM36293',
'KATM36294',
'KATM36295',
'KATM36296',
'KATM36297',
'KATM36298',
'KATM36299',
'KATM36300',
'KATM36301',
'KATM36302',
'KATM36303',
'KATM36304',
'KATM36305',
'KATM36306',
'KATM36307',
'KATM36308',
'KATM36309',
'KATM36310',
'KATM36311',
'KATM36312',
'KATM36313',
'KATM36314',
'KATM36315',
'KATM36316',
'KATM36317',
'KATM36318',
'KATM36319',
'KATM36320',
'KATM36321',
'KATM36322',
'KATM36323',
'KATM36324',
'KATM36325',
'KATM36326',
'KATM36327',
'KATM36328',
'KATM36329',
'KATM36330',
'KATM36331',
'KATM36332',
'KATM36333',
'KATM36334',
'KATM36335',
'KATM36336',
'KATM36337',
'KATM36338',
'KATM36339',
'KATM36340',
'KATM36341')
ORDER BY guid ;
