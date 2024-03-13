-- wow!!!

SELECT DISTINCT ON (collobj, itype) *
FROM (
  VALUES 
    (1, 'uam1', 'colln', '10'),
    (2, 'uam1', 'idn',   'a2'),
    (3, 'uam1', 'colln', '12'),
    (4, 'uam2', 'idn',   'b2'),
    (5, 'uam2', 'colln', '13'))
  AS T (id, collobj, itype, value);
