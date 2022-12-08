-- Specimen count, within time range, for taxonomic class

SELECT count(*) as "count"
  FROM flat
  WHERE
    entereddate >= '2021-01-01' AND
    entereddate <= '2021-12-31' AND
    guid ~ 'UAMb:Herb' AND
    phylum = 'Bryophyta' AND
    imageurl IS NULL AND
    dec_lat IS NULL AND
    collectors ~ '[Uu]nknown' AND
    spec_locality = 'No specific locality recorded.'
    
-- Comment out any line to explore the resulting count

-- Get evidence of any kind of transcription using:
-- AND (
--   dec_lat IS NOT NULL OR
--   collectors !~ '[Uu]nknown' OR
--   spec_locality != 'No specific locality recorded.'
-- )
