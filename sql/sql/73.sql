-- Agents, for Della

SELECT 
  a_last.attribute_value as L,
  a_first.attribute_value as F ,
  agent.preferred_agent_name,
  CONCAT('https://arctos.database.museum/agent/', agents_with_roles.agent_id) as url,
  CONCAT_WS(', ',
  n_creator.n_creator,
  n_collector.n_collector,
  n_copyright.n_copyright,
  n_subject.n_subject) AS role,
  a_profile.attribute_value as profile 
FROM ( SELECT
  DISTINCT collector.agent_id
  FROM flat, collector
  WHERE flat.collection_object_id = collector.collection_object_id AND
  guid_prefix = 'UAM:Art'
) AS agents_with_roles
LEFT JOIN (
  SELECT agent_id, 'creator' AS n_creator
  FROM collector
  WHERE collector_role = 'creator'
  GROUP BY agent_id
) AS n_creator
ON agents_with_roles.agent_id = n_creator.agent_id
LEFT JOIN (
  SELECT agent_id, 'collector' AS n_collector
  FROM collector
  WHERE collector_role = 'collector'
  GROUP BY agent_id
) AS n_collector
ON agents_with_roles.agent_id = n_collector.agent_id
LEFT JOIN (
  SELECT agent_id, 'copyright holder' AS n_copyright
  FROM collector
  WHERE collector_role = 'copyright holder'
  GROUP BY agent_id
) AS n_copyright
ON agents_with_roles.agent_id = n_copyright.agent_id
LEFT JOIN (
  SELECT agent_id, 'subject' AS n_subject
  FROM collector
  WHERE collector_role = 'subject'
  GROUP BY agent_id
) AS n_subject
ON agents_with_roles.agent_id = n_subject.agent_id

LEFT JOIN
  agent
ON agents_with_roles.agent_id = agent.agent_id

LEFT JOIN
  agent_attribute AS a_last
ON agents_with_roles.agent_id = a_last.agent_id AND
  a_last.attribute_type = 'last name'

LEFT JOIN
  agent_attribute AS a_first
ON agents_with_roles.agent_id = a_first.agent_id AND
  a_first.attribute_type = 'first name'

LEFT JOIN
  agent_attribute AS a_profile
ON agents_with_roles.agent_id = a_profile.agent_id AND
  a_profile.attribute_type = 'profile'

ORDER BY a_last.attribute_value, a_first.attribute_value, agent.preferred_agent_name 
LIMIT 1000

  
-- TIMES OUT:
-- LEFT JOIN ( SELECT
--   agent_id, STRING_AGG(attribute_value, ', ') AS L
--   FROM agent_attribute
--   WHERE attribute_type = 'last name'
--   GROUP BY agent_id
-- )
-- AS a_last
-- ON agents_with_roles.agent_id = a_last.agent_id

-- LEFT JOIN ( SELECT
--   agent_id, STRING_AGG(attribute_value, ', ') AS F
--   FROM agent_attribute
--   WHERE attribute_type = 'first name'
--   GROUP BY agent_id
-- )
-- AS a_first
-- ON agents_with_roles.agent_id = a_first.agent_id

-- LEFT JOIN ( SELECT
--   agent_id, STRING_AGG(attribute_value, ', ') AS M
--   FROM agent_attribute
--   WHERE attribute_type = 'middle name'
--   GROUP BY agent_id
-- )
-- AS a_middle
-- ON agents_with_roles.agent_id = a_middle.agent_id

