-- Admin, recent edits to specimens, summarize bu user and guid

SELECT user_p_name, guid_prefix, COUNT(*) from flat_edit_history, flat
WHERE flat.collection_object_id = flat_edit_history.collection_object_id AND
edit_date::date > '2023-01-01' AND
institution_acronym = 'UAM' AND
collection_cde = 'Herb'
GROUP BY user_p_name, guid_prefix

