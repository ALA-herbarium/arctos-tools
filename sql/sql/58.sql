-- GUID, from list of ALAACs, using flat only

SELECT REGEXP_REPLACE(othercatalognumbers, '^.*ALAAC ([^ ]+) .*$', '\1')
  AS alaac, guid
FROM flat
WHERE REGEXP_REPLACE(othercatalognumbers, '^.*ALAAC ([^ ]+) .*$', '\1')
  IN ('L12347', 'L12341')
