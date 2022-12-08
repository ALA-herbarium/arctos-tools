-- Specimen count, within time range, for taxonomic class, summarized for different levels of digitization

SELECT
  a.x as "no photo, no locn", 
  b.x as "photo, no locn", 
  c.x as "no photo, locn", 
  d.x as "photo, locn",
  e.x as "total"
FROM
( SELECT count(*) as x
  FROM flat
  WHERE entereddate >= '2021-01-01'
  AND entereddate <= '2021-12-31'
  AND guid ~ 'UAMb:Herb'
  AND phylum = 'Bryophyta'
  AND imageurl IS NULL
  AND dec_lat IS NULL
) AS a,
( SELECT count(*) as x
  FROM flat
  WHERE entereddate >= '2021-01-01'
  AND entereddate <= '2021-12-31'
  AND guid ~ 'UAMb:Herb'
  AND phylum = 'Bryophyta'
  AND imageurl IS NOT NULL
  AND dec_lat IS NULL
) AS b,
( SELECT count(*) as x
  FROM flat
  WHERE entereddate >= '2021-01-01'
  AND entereddate <= '2021-12-31'
  AND guid ~ 'UAMb:Herb'
  AND phylum = 'Bryophyta'
  AND imageurl IS NULL
  AND dec_lat  IS NOT NULL
) AS c,
( SELECT count(*) as x
  FROM flat
  WHERE entereddate >= '2021-01-01'
  AND entereddate <= '2021-12-31'
  AND guid ~ 'UAMb:Herb'
  AND phylum = 'Bryophyta'
  AND imageurl IS NOT NULL
  AND dec_lat IS NOT NULL
) AS d,
( SELECT count(*) as x
  FROM flat
  WHERE entereddate >= '2021-01-01'
  AND entereddate <= '2021-12-31'
  AND guid ~ 'UAMb:Herb'
  AND phylum = 'Bryophyta'
) AS e


