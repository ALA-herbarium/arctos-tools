-- Identifications, for a list of GUIDs

SELECT f.guid, f.collection_object_id,
  i.identification_id, i.scientific_name, i.made_date
FROM (
  SELECT guid, collection_object_id
  FROM flat
  WHERE guid IN
    ('UAM:Herb:141482', 'UAM:Herb:147801', 'UAM:Herb:147808',
     'UAM:Herb:148352', 'UAM:Herb:148354', 'UAM:Herb:148428',
     'UAM:Herb:39427', 'UAM:Herb:68501')
) AS f
JOIN identification
AS i ON
f.collection_object_id = i.collection_object_id
ORDER BY f.guid;


