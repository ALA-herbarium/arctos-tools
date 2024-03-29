-- GUID, from list of ALAACs

SELECT display_value, flat.guid FROM 
coll_obj_other_id_num, flat 
WHERE coll_obj_other_id_num.collection_object_id = flat.collection_object_id
AND display_value IN ('1234', '10002')
AND other_id_type = 'ALAAC';


