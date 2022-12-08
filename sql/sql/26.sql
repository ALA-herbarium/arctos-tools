-- Identifications, for a list of GUIDs, filtered by date for that GUID

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
WHERE (f.guid, i.made_date) IN
  (('UAM:Herb:141482', '2003-07-31'), 
   ('UAM:Herb:147801', '2004-01-01'), 
   ('UAM:Herb:147808', '2004-07-17'), 
   ('UAM:Herb:148352', '2004-07-17'), 
   ('UAM:Herb:148354', '2004-07-17'), 
   ('UAM:Herb:148428', '2004-07-17'), 
   ('UAM:Herb:39427', '2001-07-01'), 
   ('UAM:Herb:68501', '2003-07-12'))
ORDER BY f.guid;
