-- Specimens, all, for an accession, key identifier fields

SELECT
  REGEXP_REPLACE(othercatalognumbers,
    '^.*ALAAC=([ABLV]?[0-9]+).*$', '\1')
    AS alaac,
  guid,
  accession,
  REGEXP_REPLACE(othercatalognumbers,
    '^.*U\. S\. National Park Service catalog=([A-Z]+ *[0-9]+).*$', '\1')
    AS npscatalog,
  REGEXP_REPLACE(othercatalognumbers,
    '^.*U\. S\. National Park Service accession=([A-Z]+-[0-9]+).*$', '\1')
    AS npsaccession
FROM flat
WHERE accession = '2010.18.Herb'
ORDER BY alaac ;

