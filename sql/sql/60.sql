-- GUIDs, where the is no attribute

SELECT guid, attributes
FROM flat
WHERE guid_prefix = 'UAM:EH' AND
  attributes !~ 'culture of origin='
LIMIT 100

