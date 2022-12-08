-- Specimens, from a list of GUID numbers, return fields for NPS checking

SELECT * FROM (
  SELECT
    -- Question
    '' AS "UAM Question",
    -- Answer
    '' AS "NPS Answer",
    -- NPS Field
    '' AS "Assumed NPS Field#",
    -- NPS catalog
    CASE WHEN othercatalognumbers ~ 'National Park Service [Cc]atalog'
      THEN REGEXP_REPLACE(othercatalognumbers,
      '^.*U\. S\. National Park Service [Cc]atalog=([A-Z]+ *[0-9]+).*$', '\1')
      ELSE NULL END
      AS "NPS Catalog",
    -- NPS accession
    CASE WHEN othercatalognumbers ~ 'National Park Service [Aa]ccession'
      THEN REGEXP_REPLACE(othercatalognumbers,
      '^.*U\. S\. National Park Service [Aa]ccession=([A-Z]+-[0-9]+).*$', '\1')
      ELSE NULL END
      AS "NPS Accession",
    -- GUID
    guid,
    -- ALAAC
    CASE WHEN othercatalognumbers ~ 'ALAAC'
      THEN REGEXP_REPLACE(othercatalognumbers,
        '^.*ALAAC=([ABLV]?[0-9]+).*$', '\1')
      ELSE NULL END
      AS ALAAC,
    -- Taxon
    scientific_name AS "Scientific Name",
    -- Determiner
    identifiedby AS "Determiner",
    -- Date
    verbatim_date AS "Collection date",
    -- Collectors
    collectors AS "Collectors",
    -- Locn
    verbatim_locality AS "Locality",
    -- Habitat
    habitat AS "Habitat",
    -- Coords
    dec_lat AS "Latitude",
    dec_long AS "Longitude",
    -- Elev
    verbatimelevation AS "Elevation"
  FROM flat
  -- include for search time efficiency:
  WHERE guid ~ 'UAMb?:(Alg|Herb)'
) AS A
WHERE A.guid IN ('UAM:Herb:243406', 'UAM:Herb:244304') -- <- list GUIDs here
ORDER BY A.guid ;
