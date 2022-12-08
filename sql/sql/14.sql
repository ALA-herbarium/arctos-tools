-- Specimens, from a list of ALAAC/GUID numbers, return primary info fields

SELECT * FROM (
  SELECT
    -- ALAAC
    CASE WHEN othercatalognumbers ~ 'ALAAC'
      THEN REGEXP_REPLACE(othercatalognumbers,
        '^.*ALAAC=([ABLV]?[0-9]+).*$', '\1')
      ELSE NULL END
      AS alaac,
    guid,
    -- Arctos accession
    accession as arctosacc,
    -- NPS catalog
    CASE WHEN othercatalognumbers ~ 'National Park Service [Cc]atalog'
      THEN REGEXP_REPLACE(othercatalognumbers,
      '^.*U\. S\. National Park Service [Cc]atalog=([A-Z]+ *[0-9]+).*$', '\1')
      ELSE NULL END
      AS npscatalog,
    -- NPS accession
    CASE WHEN othercatalognumbers ~ 'National Park Service [Aa]ccession'
      THEN REGEXP_REPLACE(othercatalognumbers,
      '^.*U\. S\. National Park Service [Aa]ccession=([A-Z]+-[0-9]+).*$', '\1')
      ELSE NULL END
      AS npsaccession,
    verbatim_date,
    collectors,
    verbatim_locality,
    higher_geog,
    spec_locality,
    dec_lat,
    dec_long,
    verbatimelevation,
    scientific_name,
    identifiedby
  FROM flat
  -- include for search time efficiency:
  WHERE guid ~ 'UAMb?:(Alg|Herb)'
) AS A
WHERE A.alaac IN ('V168856', 'V168857', 'V168858')
-- OR: WHERE A.guid IN ('UAM:Herb:243406', 'UAM:Herb:244304', ...)
ORDER BY A.alaac ;

