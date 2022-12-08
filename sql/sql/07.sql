-- Admin, most active days and table edits, list, sort by number of specimens updated

SELECT edit_date::date, edited_table, count(*)
FROM flat_edit_history
WHERE user_p_name = '__Q1__'
GROUP BY edit_date::date, edited_table
ORDER BY count(*) DESC
LIMIT 10


