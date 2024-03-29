-- GUID, from barcode, not using flat json

SELECT sheet.barcode,
  sheet.container_id AS cont_parent_id,
  sheet.container_type AS cont_parent_type,
  plant.container_id AS cont_child_id,
  plant.container_type AS cont_child_type,
  specimen_part.collection_object_id AS part_id,
  specimen_part.part_name AS part_type,
  flat.guid
FROM container AS sheet
JOIN container AS plant
  ON plant.parent_container_id = sheet.container_id
JOIN coll_obj_cont_hist AS cont_part_link
  ON cont_part_link.container_id = plant.container_id
JOIN specimen_part
  ON cont_part_link.collection_object_id = specimen_part.collection_object_id
JOIN flat
  ON specimen_part.derived_from_cat_item = flat.collection_object_id
WHERE sheet.barcode IN ('H1283903','H1283901');
