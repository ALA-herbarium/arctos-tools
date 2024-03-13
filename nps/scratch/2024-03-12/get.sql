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
  TO_CHAR(flat.ended_date::date, 'FMMM/FMDD/YYYY') AS "Collection Date",
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
  TO_CHAR(entereddate::date, 'FMMM/FMDD/YYYY') AS "Catalog Date",
  -- 27 - Identified By (direct)
  CONCAT_WS(', ', IDENTL.attribute_value, IDENTF.attribute_value)
    AS "Identified By",
  -- 28 - Ident Date (transform)
  TO_CHAR(flat.made_date::date, 'FMMM/FMDD/YYYY') AS "Ident Date",
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
  TO_CHAR(flat.ended_date::date, 'YYYY') AS "Field Season",
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
  IN ('BELA56173','BELA56174','BELA56175','BELA56176')
ORDER BY guid ;

