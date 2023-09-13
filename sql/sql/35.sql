-- Media, all, with barcode and Guid

SELECT
  guid,
  (partdetail::json->>0)::json->>'bc' AS bc,
  media_uri
FROM flat
LEFT JOIN media_relations
  ON media_relations.cataloged_item_id = flat.collection_object_id
LEFT JOIN media
  ON media.media_id = media_relations.media_id
WHERE flat.guid ~ 'UAMb?:(Herb|Alg)' ;
