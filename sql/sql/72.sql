-- Specimens, extract recordNumbers

SELECT
guid, identifiers::text, 
CASE
 WHEN (identifiers::jsonb @? '$[*] ? (@.identifier_type == "collector number")')::integer = 1
 THEN REGEXP_REPLACE(JSONB_PATH_QUERY_ARRAY(identifiers::jsonb , '$[*] ? (@.identifier_type == "collector number") .identifier')::text ,'[\[\]"]+','','g')
 ELSE NULL END
from filtered_flat 
limit 500
