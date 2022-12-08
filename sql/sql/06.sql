-- Specimens, with a NPS catalog number, total count

SELECT count(*)
FROM flat
WHERE othercatalognumbers ~ '(National Park Service|NPS)'
  AND institution_acronym = 'UAM'
  AND collection_cde = 'Herb' ;

-- Need both NPS and National Park Service:
-- s elect count(*) from flat where othercatalognumbers like '%NPS%'
-- and othercatalognumbers not like '%National Park Service%'"
