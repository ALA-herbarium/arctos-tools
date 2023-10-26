-- Digitization progress, for N, Central and S Amercia 
-- https://gist.github.com/camwebb/62656cdca4c5b789256debda196cc7e6

SELECT z.genus,
  a.c AS N_all, b.c AS N_geo, c.c AS N_img, d.c AS N_tcn,
  e.c AS C_all, f.c AS C_geo, g.c AS C_img, h.c AS C_tcn,
  i.c AS S_all, j.c AS S_geo, k.c AS S_img, l.c AS S_tcn FROM

-- All genera
(SELECT DISTINCT genus FROM flat
  WHERE guid_prefix = 'UAM:Herb') AS z

LEFT JOIN
-- databased, N Am north of Mexico
(SELECT genus, count(*) AS c FROM flat
  WHERE guid_prefix = 'UAM:Herb' AND
  (country != 'Mexico' AND continent_ocean = 'North America')
  GROUP BY genus ) AS a
  ON z.genus = a.genus
LEFT JOIN
-- georeferenced, N Am north of Mexico
(SELECT genus, count(*) AS c FROM flat
  WHERE guid_prefix = 'UAM:Herb' AND
  (country != 'Mexico' AND continent_ocean = 'North America') AND
  dec_lat IS NOT NULL
  GROUP BY genus ) AS b
  ON z.genus = b.genus
LEFT JOIN
-- imaged, N Am north of Mexico
  (SELECT genus, count(*) AS c FROM flat
  WHERE guid_prefix = 'UAM:Herb' AND
  (country != 'Mexico' AND continent_ocean = 'North America') AND
  imageurl IS NOT NULL
  GROUP BY genus ) AS c
  ON z.genus = c.genus
LEFT JOIN
-- Total needing some TCN work, N Am north of Mexico
  (SELECT genus, count(*) AS c FROM flat
  WHERE guid_prefix = 'UAM:Herb' AND
  (country != 'Mexico' AND continent_ocean = 'North America') AND
  (dec_lat IS NULL OR imageurl IS NULL)
  GROUP BY genus ) AS d
  ON z.genus = d.genus

LEFT JOIN
-- databased, Mex and C Am
  (SELECT genus, count(*) AS c FROM flat
  WHERE guid_prefix = 'UAM:Herb' AND
  (country = 'Mexico' OR continent_ocean = 'Central America')
  GROUP BY genus ) AS e
  ON z.genus = e.genus
LEFT JOIN
-- georeferenced, Mex and C Am
  (SELECT genus, count(*) AS c FROM flat
  WHERE guid_prefix = 'UAM:Herb' AND
  (country = 'Mexico' OR continent_ocean = 'Central America') AND
  dec_lat IS NOT NULL
  GROUP BY genus ) AS f
  ON z.genus = f.genus
LEFT JOIN
-- imaged, Mex and C Am
  (SELECT genus, count(*) AS c FROM flat
  WHERE guid_prefix = 'UAM:Herb' AND
  (country = 'Mexico' OR continent_ocean = 'Central America') AND
  imageurl IS NOT NULL
  GROUP BY genus ) AS g
  ON z.genus = g.genus
LEFT JOIN
-- Total needing some TCN work, Mex and C Am
  (SELECT genus, count(*) AS c FROM flat
  WHERE guid_prefix = 'UAM:Herb' AND
  (country = 'Mexico' OR continent_ocean = 'Central America')  AND
  (dec_lat IS NULL OR imageurl IS NULL)
  GROUP BY genus ) AS h
  ON z.genus = h.genus

LEFT JOIN
-- databased, S America
  (SELECT genus, count(*) AS c FROM flat
  WHERE guid_prefix = 'UAM:Herb' AND
  continent_ocean = 'South America'
  GROUP BY genus ) AS i
  ON z.genus = i.genus
LEFT JOIN
-- georeferenced, S America
  (SELECT genus, count(*) AS c FROM flat
  WHERE guid_prefix = 'UAM:Herb' AND
  continent_ocean = 'South America' AND
  dec_lat IS NOT NULL
  GROUP BY genus ) AS j
  ON z.genus = j.genus
LEFT JOIN
-- imaged, S America
  (SELECT genus, count(*) AS c FROM flat
  WHERE guid_prefix = 'UAM:Herb' AND
  continent_ocean = 'South America' AND
  imageurl IS NOT NULL
  GROUP BY genus ) AS k
  ON z.genus = k.genus
LEFT JOIN
-- Total needing some TCN work, S America
  (SELECT genus, count(*) AS c FROM flat
  WHERE guid_prefix = 'UAM:Herb' AND
  continent_ocean = 'South America'  AND
  (dec_lat IS NULL OR imageurl IS NULL)
  GROUP BY genus ) AS l
  ON z.genus = l.genus

WHERE
  (a.c IS NOT NULL OR
   b.c IS NOT NULL OR
   c.c IS NOT NULL OR
   d.c IS NOT NULL OR
   e.c IS NOT NULL OR
   f.c IS NOT NULL OR
   g.c IS NOT NULL OR
   h.c IS NOT NULL OR
   i.c IS NOT NULL OR
   j.c IS NOT NULL OR
   k.c IS NOT NULL OR
   l.c IS NOT NULL )

ORDER BY z.genus;
