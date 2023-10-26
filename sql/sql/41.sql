-- Digitization progress, by phylum, by time period of new media added (see also 40.sql)

SELECT taxon, count(*) from (
  SELECT
    CASE WHEN phylum = 'Bryophyta' THEN 'moss'
      WHEN phylum = 'Pteridophyta' THEN 'fern'
      WHEN phylum = 'Ascomycota' THEN   'asco'
      WHEN phylum = 'Basidiomycota' THEN 'basidio'
      ELSE 'other' END
      AS taxon
  FROM flat, media_relations
  WHERE
    guid ~ 'UAMb?:Herb' AND
    media_relations.cataloged_item_id = flat.collection_object_id AND
    entereddate <= '2023-06-01' AND
    media_relations.created_on_date >= '2023-06-01' AND
    media_relations.created_on_date <= '2023-09-30'
) AS A
GROUP BY taxon
ORDER BY taxon
