-- Digitization progress, by phylum, by time period of date entered (see also 41.sql)

SELECT taxon, photo, geo, count(*) from (
  SELECT
    CASE WHEN phylum = 'Bryophyta' THEN 'moss'
      WHEN phylum = 'Pteridophyta' THEN 'fern'
      WHEN phylum = 'Ascomycota' THEN   'asco'
      WHEN phylum = 'Basidiomycota' THEN 'basidio'
      ELSE 'other' END
      AS taxon,
    CASE WHEN imageurl IS NOT NULL THEN 'yes'
      ELSE 'no' END
      AS photo,
    CASE WHEN dec_lat IS NOT NULL THEN 'yes'
      ELSE 'no' END
      AS geo
  FROM flat
  WHERE
    guid ~ 'UAMb?:Herb' AND
    entereddate >= '2023-06-01' AND
    entereddate <= '2023-09-30'
) AS A
GROUP BY taxon, photo, geo
ORDER BY taxon, photo, geo
