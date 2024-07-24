-- Record edits, by date and table, for an operator

SELECT edit_date::date::text, edited_table, count(*)
FROM flat_edit_history
WHERE user_p_name = 'Operator Display Name'
GROUP BY edit_date::date::text, edited_table
ORDER BY edit_date::date::text, edited_table

-- Follow up with:

-- SELECT DISTINCT guid, edited_table
-- FROM flat_edit_history, flat
-- WHERE flat_edit_history.collection_object_id = flat.collection_object_id AND
--   user_p_name = 'Operator Display Name' AND
--   edit_date::date::text = 'YYYY-MM-DD'
-- ORDER BY guid, edited_table
