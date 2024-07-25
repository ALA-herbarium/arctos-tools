-- Specimens, from a list of GUIDs, return all fields for nacompare, replacing 29.sql

SELECT
  -- 1 - Catalog # (direct)
  CONCAT_WS('',
      -- first four chars
      SUBSTRING(N.display_value,1,4),
      -- spaces
      REPEAT(' ',(12-CHAR_LENGTH(REGEXP_REPLACE(N.display_value,'[- ]+','')))),
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
  REGEXP_REPLACE(flat.scientific_name, ' +.*$','')
    AS "Sci. Name:Genus",
  -- 10 - Sci. Name:Species (split)
  REGEXP_REPLACE(flat.scientific_name, '^[^ ]+ +','')
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
  CONCAT(flat.scientific_name,
    '  vascular plant specimens mounted on herbarium sheet') AS "Description",
  -- 17 - Dimens/Weight (fixed)
  '' AS "Dimens/Weight",
  -- 18 - Collector (transform)
  REGEXP_REPLACE(
    CONCAT_WS('; ',
      REGEXP_REPLACE(
        CONCAT_WS('; ',
          CONCAT_WS(', ', COL1L.attribute_value, COL1F.attribute_value),
          CONCAT_WS(', ', COL2L.attribute_value, COL2F.attribute_value),
          CONCAT_WS(', ', COL3L.attribute_value, COL3F.attribute_value),
          CONCAT_WS(', ', COL4L.attribute_value, COL4F.attribute_value)),
        '[; ]+$',''),
      VERBAGENTS.c),
    '[; ]+$','')
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
  CASE
    WHEN CHAR_LENGTH(flat.ended_date) = 10 THEN
      TO_CHAR(flat.ended_date::date, 'FMMM/FMDD/YYYY')
    WHEN CHAR_LENGTH(flat.ended_date) = 7 THEN
      CONCAT_WS('/',SUBSTRING(flat.ended_date,6,2),
        SUBSTRING(flat.ended_date,1,4))
    WHEN CHAR_LENGTH(flat.ended_date) = 4 THEN
      flat.ended_date
    ELSE NULL END
  AS "Collection Date",
  -- 21 - Condition (fixed)
  'COM/GD' AS "Condition",
  -- 22 - Condition Desc (fixed)
  '' AS "Condition Desc",
  -- 23 - Study # (fixed)
  '' AS "Study #",
  -- 24 - Other Numbers (combine)
  CONCAT_WS('', 'UAF Accession # ', flat.accession,
    '; UAF Catalog # ', flat.guid, (
    CASE WHEN A.display_value IS NOT NULL
    THEN CONCAT_WS('', '; ALAAC # ', A.display_value)
    ELSE NULL END
    )) AS "Other Numbers",
  -- 25 - Cataloger (transform)
  UPPER(CONCAT_WS(', ', CPL.attribute_value, CPF.attribute_value))
    AS "Cataloger",
  -- 26 - Catalog Date (transform)
  TO_CHAR(entereddate::date, 'FMMM/FMDD/YYYY')
    AS "Catalog Date",
  -- 27 - Identified By (direct)
  -- TODO: add middle initial
  CASE
    WHEN IDENTL.attribute_value IS NOT NULL
    THEN CONCAT_WS(', ', IDENTL.attribute_value, IDENTF.attribute_value)
    ELSE 'Not provided' END
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
  CONCAT_WS('', dec_lat, 'N/',  REPLACE(flat.dec_long::varchar,'-',''),'W')
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
FROM flat

-- Other identifiers:

-- N = NPS catalog
LEFT JOIN coll_obj_other_id_num AS N
ON flat.collection_object_id = N.collection_object_id
  AND N.other_id_type = 'U. S. National Park Service catalog'

-- C = NPS accession
LEFT JOIN coll_obj_other_id_num AS C
ON flat.collection_object_id = C.collection_object_id
  AND C.other_id_type = 'U. S. National Park Service accession'

-- ALAAC (unique per record)
LEFT JOIN coll_obj_other_id_num AS A
ON flat.collection_object_id = A.collection_object_id
  AND A.other_id_type = 'ALAAC'

-- Collector number (select one only)
LEFT JOIN (
  SELECT DISTINCT ON (collection_object_id, other_id_type)
    collection_object_id, other_id_type, display_value
  FROM coll_obj_other_id_num ) AS CN
ON flat.collection_object_id = CN.collection_object_id
  AND CN.other_id_type = 'collector number'

--Field number (select one only)
LEFT JOIN (
  SELECT DISTINCT ON (collection_object_id, other_id_type)
    collection_object_id, other_id_type, display_value
  FROM coll_obj_other_id_num ) AS FN
ON flat.collection_object_id = FN.collection_object_id
  AND FN.other_id_type = 'field number'

--identifier (select one only)
LEFT JOIN (
  SELECT DISTINCT ON (collection_object_id, other_id_type)
    collection_object_id, other_id_type, display_value
  FROM coll_obj_other_id_num ) AS ID
ON flat.collection_object_id = ID.collection_object_id
  AND ID.other_id_type = 'identifier'

-- Collector names, via collector table
-- Collector 1
LEFT JOIN collector AS COL1
ON flat.collection_object_id = COL1.collection_object_id AND COL1.coll_order = 1
LEFT JOIN agent_attribute AS COL1L
ON COL1.agent_id = COL1L.agent_id AND COL1L.attribute_type = 'last name'
LEFT JOIN agent_attribute AS COL1F
ON COL1.agent_id = COL1F.agent_id AND COL1F.attribute_type = 'first name'

-- Collector 2
LEFT JOIN collector AS COL2
ON flat.collection_object_id = COL2.collection_object_id AND COL2.coll_order = 2
LEFT JOIN agent_attribute AS COL2L
ON COL2.agent_id = COL2L.agent_id AND COL2L.attribute_type = 'last name'
LEFT JOIN agent_attribute AS COL2F
ON COL2.agent_id = COL2F.agent_id AND COL2F.attribute_type = 'first name'

-- Collector 3
LEFT JOIN collector AS COL3
ON flat.collection_object_id = COL3.collection_object_id AND COL3.coll_order = 3
LEFT JOIN agent_attribute AS COL3L
ON COL3.agent_id = COL3L.agent_id AND COL3L.attribute_type = 'last name'
LEFT JOIN agent_attribute AS COL3F
ON COL3.agent_id = COL3F.agent_id AND COL3F.attribute_type = 'first name'

-- Collector 4
LEFT JOIN collector AS COL4
ON flat.collection_object_id = COL4.collection_object_id AND COL4.coll_order = 4
LEFT JOIN agent_attribute AS COL4L
ON COL4.agent_id = COL4L.agent_id AND COL4L.attribute_type = 'last name'
LEFT JOIN agent_attribute AS COL4F
ON COL4.agent_id = COL4F.agent_id AND COL4F.attribute_type = 'first name'

-- Collector as verbatim agent
LEFT JOIN (
  SELECT collection_object_id, STRING_AGG(attribute_value, '; ') AS c
  FROM attributes
  WHERE attributes.attribute_type = 'verbatim agent'
  GROUP BY collection_object_id
) AS VERBAGENTS
ON flat.collection_object_id = VERBAGENTS.collection_object_id

-- Entered by person, via coll_object
LEFT JOIN cataloged_item AS COLLOBJ
ON flat.collection_object_id = COLLOBJ.collection_object_id
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
ON flat.collection_object_id = IDENT.collection_object_id
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
WHERE flat.guid IN ('UAM:Herb:60374', 'UAM:Herb:60375','UAM:Herb:60376', 'UAM:Herb:100000')
ORDER BY guid ;
