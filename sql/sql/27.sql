-- Specimens, from a list of GUID numbers, return all fields for export to NPS

SELECT
  -- 1 - Catalog # (direct)
  CASE WHEN othercatalognumbers ~ 'National Park Service catalog'
    THEN REGEXP_REPLACE(REGEXP_REPLACE(othercatalognumbers,
      '^.*U\. S\. National Park Service catalog=([A-Z]+ *[0-9]+).*$', '\1'),
      ' +', ' ')
    ELSE NULL END
  AS "Catalog #",
  -- 2 - Accession # (direct)
  CASE WHEN othercatalognumbers ~ 'National Park Service accession'
    THEN REGEXP_REPLACE(othercatalognumbers,
    '^.*U\. S\. National Park Service [Aa]ccession=([A-Z]+-[0-9]+).*$', '\1')
    ELSE NULL END
  AS "Accession #",
  -- 3 - Class 1 (fixed)
  'BIOLOGY' AS "Class 1",
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
  -- CONCAT_WS(' ', species, infraspecific_rank, subspecies)
  CASE WHEN subspecies IS NULL
    THEN REPLACE(species, CONCAT(genus, ' '),'')
    ELSE REPLACE(subspecies, CONCAT(genus, ' '),'') END
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
  'Herbarium sheet' AS "Description",
  -- 17 - Dimens/Weight (fixed)
  '' AS "Dimens/Weight",
  -- 18 - Collector (transform)
  UPPER(REGEXP_REPLACE(
    REGEXP_REPLACE(
      REGEXP_REPLACE(collectors, ',.*',''),
    '[A-Z]\.',''),
    '([^ ]+) +([^ ]+)', '\2, \1'))
    AS "Collector",
  -- 19 - Collection # (direct)
  CASE WHEN othercatalognumbers ~ 'field number='
    THEN REGEXP_REPLACE(othercatalognumbers,
      '^.*field number=([^,]+).*$', '\1')
    ELSE NULL END
  AS "Collection #",
  -- 20 - Collection Date (transform)
  TO_CHAR(ended_date::date, 'mm/dd/YYYY') AS "Collection Date",
  -- 21 - Condition (fixed)
  'COM/GD' AS "Condition",
  -- 22 - Condition Desc (fixed)
  '' AS "Condition Desc",
  -- 23 - Study # (fixed)
  '' AS "Study #",
  -- 24 - Other Numbers (combine)
  CONCAT_WS('', 'Arctos=', guid, 
  CASE WHEN othercatalognumbers ~ 'ALAAC'
    THEN CONCAT_WS('', ' ALAAC=', REGEXP_REPLACE(othercatalognumbers,
      '^.*ALAAC=([ABLV]?[0-9]+).*$', '\1'))
    ELSE NULL END
    ) AS "Other Numbers",
  -- 25 - Cataloger (transform)
  UPPER(REGEXP_REPLACE(
    REGEXP_REPLACE(
      REGEXP_REPLACE(enteredby, ',.*',''),
    '[A-Z]\.',''),
    '([^ ]+) +([^ ]+)', '\2, \1')) AS "Cataloger",
  -- 26 - Catalog Date (transform)
  TO_CHAR(entereddate::date, 'mm/dd/YYYY') AS "Catalog Date",
  -- 27 - Identified By (direct)
  UPPER(REGEXP_REPLACE(
    REGEXP_REPLACE(
      REGEXP_REPLACE(identifiedby, ',.*',''),
    '[A-Z]\.',''),
    '([^ ]+) +([^ ]+)', '\2, \1')) AS "Identified By",
  -- 28 - Ident Date (transform)
  TO_CHAR(date_made_date::date, 'mm/dd/YYYY') AS "Ident Date",
  -- 29 - Repro Method (fixed)
  '' AS "Repro Method",
  -- 30 - Locality (direct)
  spec_locality AS "Locality"
  -- 31 - Unit (fixed)
  '' AS "Unit",
  -- 32 - State (fixed)
  'AK' AS "State",
  -- 33 - Reference Datum (transform)
  CASE
    WHEN datum = 'World Geodetic System 1984' THEN 'WGS 84'
    WHEN datum = 'foo1' THEN 'NAD 27'
    WHEN datum = 'foo2' THEN 'NAD 83'
    ELSE NULL END
  AS "Reference Datum"
  -- 34 - Watrbody/Drain:Waterbody (fixed)
  -- '' AS "",
  -- 35 - Watrbody/Drain:Drainage (fixed)
  -- '' AS "",
  -- 36 - UTM Z/E/N (fixed)
  -- '' AS "",
  -- 37 - Lat LongN/W (combine)
  -- '' AS "",
  -- 38 - Elevation (transform)
  -- '' AS "",
  -- 39 - Depth (fixed)
  -- '' AS "",
  -- 40 - Depos Environ (fixed)
  -- '' AS "",
  -- 41 - Habitat/Comm (fixed)
  -- '' AS "",
  -- 42 - Habitat (direct)
  -- '' AS "",
  -- 43 - Slope (fixed)
  -- '' AS "",
  -- 44 - Aspect (fixed)
  -- '' AS "",
  -- 45 - Soil Type (fixed)
  -- '' AS "",
  -- 46 - For/Per/Sub (fixed)
  -- '' AS "",
  -- 47 - Assoc Spec (fixed)
  -- '' AS "",
  -- 48 - Type Specimen (fixed)
  -- '' AS "",
  -- 49 - Threat/Endang (fixed)
  -- '' AS "",
  -- 50 - T/E Date (fixed)
  -- '' AS "",
  -- 51 - Rare (fixed)
  -- '' AS "",
  -- 52 - Exotic/Native (fixed)
  -- '' AS "",
  -- 53 - Age (fixed)
  -- '' AS "",
  -- 54 - Sex (fixed)
  -- '' AS "",
  -- 55 - Notes (fixed)
  -- '' AS "",
  -- 56 - Field Season (fixed)
  -- '' AS "",
  -- 57 - Ctrl Prop (fixed)
  -- '' AS "",
  -- 58 - Location (fixed)
  -- '' AS "",
  -- 59 - Object Status (fixed)
  -- '' AS "",
  -- 60 - Status Date (fixed)
  -- '' AS "",
  -- 61 - Catalog Folder (fixed)
  -- '' AS "",
  -- 62 - Maint. Cycle (fixed)
FROM flat
WHERE guid IN ('UAM:Herb:243406', 'UAM:Herb:244304', 'UAM:Herb:141482', 'UAM:Herb:147801', 'UAM:Herb:147808', 'UAM:Herb:148352', 'UAM:Herb:148354', 'UAM:Herb:148428', 'UAM:Herb:39427', 'UAM:Herb:68501', 'UAM:Ento:473386')
ORDER BY guid ;
