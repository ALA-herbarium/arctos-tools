-- Parts, all in ROOM20, using just flat

SELECT guid, accession,
  JSONB_PATH_QUERY(part::jsonb, '$.part_id')::text AS id,
  JSONB_PATH_QUERY(part::jsonb, '$.part_name')::text AS name,
  JSONB_PATH_QUERY(part::jsonb, '$.part_barcode')::text AS bc,
  REGEXP_REPLACE(JSONB_PATH_QUERY(part::jsonb, '$.container_path')::text,
    '.*rm 20 \(room\):\[ ([^ ]+) \].*','\1') AS freezer,
  REGEXP_REPLACE(JSONB_PATH_QUERY(part::jsonb, '$.container_path')::text,
    '.*\(([^)]+)\)"$', '\1') AS container
FROM (
  SELECT guid, accession,
    JSONB_PATH_QUERY(partdetail::jsonb,
      '$[*] ? (@.container_path like_regex " ROOM20 ")') AS part
  FROM flat
  WHERE guid_prefix ~ '^UAM'
) AS P
ORDER BY guid
