-- Localities, list changes, for a locality_id (Q1)

SELECT spec_locality, dec_lat, dec_long, whodunit, changedate::date
FROM locality_archive
WHERE locality_id = __Q1__
;
