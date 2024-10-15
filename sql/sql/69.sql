-- Parts, all, in a specific freezer rack

SELECT
  rack.barcode     AS "rack",
  rackpos.label    AS "rackpos",
  box.description  AS "box",
  vial.label       AS "vial",
  collobj.label    AS "obj",
  flat.guid
FROM ( 
  SELECT * FROM container
  WHERE container_type = 'freezer rack' and barcode = 'C04414' 
) AS rack
LEFT JOIN (
  SELECT * FROM container
  where container_type = 'freezer rack position'
) AS rackpos ON rack.container_id = rackpos.parent_container_id
LEFT JOIN (
  SELECT * FROM container
  where container_type = 'freezer box'
) AS box ON rackpos.container_id = box.parent_container_id
LEFT JOIN (
  SELECT * FROM container
  where container_type = 'cryovial'
) AS vial ON box.container_id = vial.parent_container_id
LEFT JOIN (
  SELECT * FROM container
  where container_type = 'collection object'
) AS collobj ON vial.container_id = collobj.parent_container_id
LEFT JOIN coll_obj_cont_hist
          ON collobj.container_id = coll_obj_cont_hist.container_id
LEFT JOIN specimen_part
          ON coll_obj_cont_hist.collection_object_id = specimen_part.collection_object_id
LEFT JOIN flat
          ON specimen_part.derived_from_cat_item = flat.collection_object_id


-- Note... this kind of structure is too slow!!
-- SELECT rack.barcode, rackpos.label, box.description, vial.*
-- FROM      container AS rack
-- LEFT JOIN container AS rackpos
--   ON  rack.barcode           = 'C04414'
--   AND rack.container_type    = 'freezer rack' 
--   AND rackpos.container_type = 'freezer rack position'
--   AND rack.container_id      = rackpos.parent_container_id
-- LEFT JOIN container AS box
--   ON  box.container_type     = 'freezer box'
--   AND rackpos.container_id   = box.parent_container_id
-- LEFT JOIN container AS vial
--   ON  vial.container_type     = 'cryovial'
--   AND box.container_id        = vial.parent_container_id
