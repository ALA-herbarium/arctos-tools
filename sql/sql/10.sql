-- Specimen details from a list of GUIDs

SELECT guid, accession, collectors, spec_locality, dec_long, imageurl
FROM flat
WHERE guid IN
  ('UAMb:Herb:47','UAMb:Herb:48','UAMb:Herb:49','UAMb:Herb:50');
