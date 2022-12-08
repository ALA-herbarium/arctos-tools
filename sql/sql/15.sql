-- Specimens, all NPS specimens, listing key data

SELECT
  REGEXP_REPLACE(othercatalognumbers,
  '^.*ALAAC=([ABLV]?[0-9]+).*$', '\1')
  AS alaac,
  guid,
  accession,
  REGEXP_REPLACE(othercatalognumbers,
    '^.*U\. S\. National Park Service catalog=([A-Z]*-? *[0-9]+).*$', '\1')
    AS npscatalog,
  REGEXP_REPLACE(othercatalognumbers,
    '^.*U\. S\. National Park Service accession=([A-Z]*-?[0-9]*).*$', '\1')
    AS npsaccession
FROM flat
WHERE guid ~ 'UAMb?:(Alg|Herb)' AND
  othercatalognumbers ~ 'U\. S\. National Park Service'
ORDER BY npsaccession, alaac ;
