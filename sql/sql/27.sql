-- Specimens, from a list of GUID numbers, return all fields for export to NPS

SELECT
  -- 1 - Catalog # (direct)
  CASE WHEN othercatalognumbers ~ 'National Park Service catalog'
    THEN CONCAT_WS('',
      -- first four chars
      SUBSTRING(REGEXP_REPLACE(othercatalognumbers,
      '^.*U\. S\. National Park Service catalog=([A-Z]+ *[0-9]+).*$', '\1')
      ,1,4),
      -- spaces
      REPEAT(' ', (12-CHAR_LENGTH(REGEXP_REPLACE(REGEXP_REPLACE(
      othercatalognumbers,
      '^.*U\. S\. National Park Service catalog=([A-Z]+ *[0-9]+).*$', '\1'),
      ' +','')))),
      -- numbers
      REGEXP_REPLACE(SUBSTRING(REGEXP_REPLACE(othercatalognumbers,
      '^.*U\. S\. National Park Service catalog=([A-Z]+ *[0-9]+).*$', '\1'),
      5),' +',''))
    ELSE NULL END
  AS "Catalog #",
  -- 2 - Accession # (direct)
  CASE WHEN othercatalognumbers ~ 'National Park Service accession'
    THEN REGEXP_REPLACE(othercatalognumbers,
    '^.*U\. S\. National Park Service [Aa]ccession=([A-Z]+-[0-9]+).*$', '\1')
    ELSE NULL END
  AS "Accession #",
  -- 3 - Class 1 (fixed)
  -- 'BIOLOGY' AS "Class 1",
  -- 4 - Kingdom (direct)
  kingdom AS "Kingdom",
  -- 5 - Phylum/Division (direct)
  phylum AS "Phylum/Division",
  -- 6 - Class (direct)
  phylclass AS "Class",
  -- 7 - Order (fixed)
  phylorder AS "Order",
  -- 8 - Family (fixed)
  family AS "Family",
  -- 9 - Sci. Name:Genus (split)
  genus AS "Sci. Name:Genus",
  -- 10 - Sci. Name:Species (split)
  CASE WHEN subspecies IS NULL
    THEN REPLACE(species, CONCAT(genus, ' '),'')
    ELSE REPLACE(subspecies, CONCAT(genus, ' '),'') END
    AS "Sci. Name:Species",
  -- 11 - Common Name (fixed)
  '' AS "Common Name",
  -- 12 - TSN (fixed)
  '' AS "TSN",
  -- 13 - Item Count (direct)
  -- 1 AS "Item Count",
  -- 14 - Quantity (fixed)
  -- '' AS "Quantity",
  -- 15 - Storage Unit (fixed)
  -- 'EA' AS "Storage Unit",
  -- 16 - Description (fixed)
  CONCAT(species, '; whole organism') AS "Description",
  -- 17 - Dimens/Weight (fixed)
  -- '' AS "Dimens/Weight",
  -- 18 - Collector (transform)
  REGEXP_REPLACE(
    REGEXP_REPLACE(
      REGEXP_REPLACE(collectors, ',.*',''),
    '[A-Z]\.',''),
    '([^ ]+) +([^ ]+)', '\2, \1')
    AS "Collector",
  -- 19 - Collection # (direct)  ** edit **
  CASE
    WHEN othercatalognumbers ~ 'collector number='
    THEN REGEXP_REPLACE(othercatalognumbers,
      '^.*collector number=([^,]+).*$', '\1')
    WHEN othercatalognumbers ~ 'field number='
    THEN REGEXP_REPLACE(othercatalognumbers,
      '^.*field number=([^,]+).*$', '\1')
    WHEN othercatalognumbers ~ 'other identifier='
    THEN REGEXP_REPLACE(othercatalognumbers,
      '^.*other identifier=([^,]+).*$', '\1')
    ELSE NULL END
  AS "Collection #",
  -- 20 - Collection Date (transform)
  TO_CHAR(ended_date::date, 'FMMM/FMDD/YYYY') AS "Collection Date",
  -- 21 - Condition (fixed)  
  (partdetail::json->>0)::json->>'cd' AS "Condition",
  -- 22 - Condition Desc (fixed)
  -- '' AS "Condition Desc",
  -- 23 - Study # (fixed)
  -- '' AS "Study #",
  -- 24 - Other Numbers (combine)
  CONCAT_WS('', 'Arctos=', guid, 
  CASE WHEN othercatalognumbers ~ 'ALAAC'
    THEN CONCAT_WS('', ' ALAAC=', REGEXP_REPLACE(othercatalognumbers,
      '^.*ALAAC=([ABLV]?[0-9]+).*$', '\1'))
    ELSE NULL END
    ) AS "Other Numbers",
  -- 25 - Cataloger (transform)  ** only in New records **
  REGEXP_REPLACE(
    REGEXP_REPLACE(
      REGEXP_REPLACE(enteredby, ',.*',''),
    '[A-Z]\.',''),
    '([^ ]+) +([^ ]+)', '\2, \1') AS "Cataloger",
  -- 26 - Catalog Date (transform)   ** only in New records **
  TO_CHAR(entereddate::date, 'FMMM/FMDD/YYYY') AS "Catalog Date",
  -- 27 - Identified By (direct)
  REGEXP_REPLACE(
    REGEXP_REPLACE(
      REGEXP_REPLACE(identifiedby, ',.*',''),
    '[A-Z]\.',''),
    '([^ ]+) +([^ ]+)', '\2, \1') AS "Identified By",
  -- 28 - Ident Date (transform)
  TO_CHAR(date_made_date::date, 'FMMM/FMDD/YYYY') AS "Ident Date",
  -- 29 - Repro Method (fixed)
  -- '' AS "Repro Method",
  -- 30 - Locality (direct)
  verbatim_locality AS "Locality",
  -- 31 - Unit (fixed)
  -- '' AS "Unit",
  -- 32 - State (fixed)
  -- 'AK' AS "State",
  -- 33 - Reference Datum (transform)   ** NOT FOR NOW, FIX LATER **
  -- CASE
  --   WHEN datum = 'World Geodetic System 1984' THEN 'WGS 84'
  --   WHEN datum = 'North American Datum 1927' THEN 'NAD 27'
  --   WHEN datum = 'North American Datum 1983' THEN 'NAD 83'
  --   ELSE NULL END
  -- AS "Reference Datum",
  -- 34 - Watrbody/Drain:Waterbody (fixed)
  -- '' AS "Watrbody/Drain:Waterbody",
  -- 35 - Watrbody/Drain:Drainage (fixed)
  -- '' AS "Watrbody/Drain:Drainage",
  -- 36 - UTM Z/E/N (fixed)
  -- '' AS "UTM Z/E/N",
  -- 37 - Lat LongN/W (combine)
  -- CONCAT_WS('', 'N', dec_lat, '/W',  REPLACE(dec_long::varchar,'-',''))
  CONCAT_WS('', dec_lat, ',', dec_long)
    AS "Lat LongN/W",
  -- 38 - Elevation (transform)
  CASE WHEN max_elev_in_m IS NOT NULL
    THEN CONCAT_WS('', max_elev_in_m, ' m')
  ELSE NULL END
    AS "Elevation",
  -- 39 - Depth (fixed)
  -- '' AS "Depth",
  -- 40 - Depos Environ (fixed)
  -- '' AS "Depos Environ",
  -- 41 - Habitat/Comm (fixed)
  -- '' AS "Habitat/Comm",
  -- 42 - Habitat (direct)
  habitat AS "Habitat",
  -- 43 - Slope (fixed)
  -- '' AS "Slope",
  -- 44 - Aspect (fixed)
  -- '' AS "Aspect",
  -- 45 - Soil Type (fixed)
  -- '' AS "Soil Type",
  -- 46 - For/Per/Sub (fixed)
  -- '' AS "For/Per/Sub",
  -- 47 - Assoc Spec (fixed)
  -- '' AS "Assoc Spec",
  -- 48 - Type Specimen (fixed)
  typestatus AS "Type Specimen",
  -- 49 - Threat/Endang (fixed)
  -- '' AS "Threat/Endang",
  -- 50 - T/E Date (fixed)
  -- '' AS "T/E Date",
  -- 51 - Rare (fixed)
  -- '' AS "Rare",
  -- 52 - Exotic/Native (fixed)
  -- '' AS "Exotic/Native",
  -- 53 - Age (fixed)
  -- '' AS "Age",
  -- 54 - Sex (fixed)
  -- '' AS "Sex",
  -- 55 - Notes (fixed)
  -- '' AS "Notes",
  -- 56 - Field Season
  TO_CHAR(ended_date::date, 'YYYY') AS "Field Season"
  -- 57 - Ctrl Prop (fixed)
  -- 'N' AS "Ctrl Prop",
  -- 58 - Location (fixed)
  -- 'UAMN - ALA HERBARIUM' AS "Location",
  -- 59 - Object Status (fixed)
  -- 'LOAN OUT – NON-NPS – NON-FEDERAL' AS "Object Status",
  -- 60 - Status Date (fixed)
  -- '' AS "Status Date",
  -- 61 - Catalog Folder (fixed)
  -- 'N' AS "Catalog Folder",
  -- 62 - Maint. Cycle (fixed)
  -- '' AS "Maint. Cycle"
FROM flat
WHERE guid IN ('UAM:Herb:243406', 'UAM:Herb:244304', 'UAM:Herb:141482', 'UAM:Herb:147801', 'UAM:Herb:147808', 'UAM:Herb:148352', 'UAM:Herb:148354', 'UAM:Herb:148428', 'UAM:Herb:39427', 'UAM:Herb:68501')
ORDER BY guid ;
