-- Admin, recent edits to specimens, list, for username (Q1)

SELECT guid, edit_date::date, edited_table
FROM flat, flat_edit_history
WHERE flat.collection_object_id = flat_edit_history.collection_object_id
  AND user_p_name = '__Q1__'
ORDER BY edit_date DESC
LIMIT 30

-- ALA users: steffi, camwebb, susitna, bjheitz
-- other possible filters:
--   edited_table IN ('locality', 'identification', 'specimen_event') 
--   edit_date >= '2022-11-01'
