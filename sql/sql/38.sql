-- GUID, find from barcode in media URL

SELECT
  guid
FROM flat, media_relations, media
WHERE media_relations.cataloged_item_id = flat.collection_object_id AND
  media.media_id = media_relations.media_id
  AND media_uri ~ 'H1048814';

