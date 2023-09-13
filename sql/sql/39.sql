-- Specimens, total count, from Russia, with image during time period

SELECT COUNT(*) FROM (
  SELECT DISTINCT guid
  FROM flat, media_relations
  WHERE guid ~ 'UAMb?:(Herb|Alg)' AND
  higher_geog ~ 'Russia' AND
  media_relations.cataloged_item_id = flat.collection_object_id AND
  media_relations.created_on_date >= '2021-05-01'
) AS A ;
