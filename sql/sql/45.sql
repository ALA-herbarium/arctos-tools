-- GLOBAL TCN status

SELECT taxon, photo, locninfo, geo, count(*) from (
  SELECT
    CASE WHEN phylum ~ '^Bryophyta' THEN 'moss'
      -- assume very few non-lich fungi
      WHEN    kingdom ~ '^Fungi'    THEN 'lichen'
      ELSE NULL END
      AS taxon,
    CASE WHEN imageurl IS NOT NULL THEN 'yes'
      ELSE 'no' END
      AS photo,
    CASE WHEN dec_lat IS NOT NULL THEN 'yes'
      ELSE 'no' END
      AS geo,
    CASE 
      WHEN spec_locality !~ 'No specific locality recorded.'
      AND spec_locality !~ 'Unknown, North America'
      AND spec_locality !~ 'unknown'
    THEN 'yes' ELSE 'no' END
    AS locninfo
  FROM flat
  WHERE
    guid ~ 'UAMb:Herb' AND
    ( phylum ~ '^Bryophyta' OR 
      kingdom ~ '^Fungi' )
) AS A
GROUP BY taxon, photo, locninfo, geo
ORDER BY taxon, photo, locninfo, geo

