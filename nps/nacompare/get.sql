SELECT
  -- 1 - Catalog # (direct)
  CASE WHEN othercatalognumbers ~ 'National Park Service catalog'
    THEN CONCAT_WS('',
      -- first four chars
      SUBSTRING(REGEXP_REPLACE(othercatalognumbers,
      '^.*U\. S\. National Park Service catalog=([A-Z]+ *[0-9]+).*$', '\1')
      ,1,4),
      -- spaces
      REPEAT(' ', (12-CHAR_LENGTH(REGEXP_REPLACE(REGEXP_REPLACE(
      othercatalognumbers,
      '^.*U\. S\. National Park Service catalog=([A-Z]+ *[0-9]+).*$', '\1'),
      ' +','')))),
      -- numbers
      REGEXP_REPLACE(SUBSTRING(REGEXP_REPLACE(othercatalognumbers,
      '^.*U\. S\. National Park Service catalog=([A-Z]+ *[0-9]+).*$', '\1'),
      5),' +',''))
    ELSE NULL END
  AS "Catalog #",
  -- 2 - Accession # (direct)
  CASE WHEN othercatalognumbers ~ 'National Park Service accession'
    THEN REGEXP_REPLACE(othercatalognumbers,
    '^.*U\. S\. National Park Service [Aa]ccession=([A-Z]+-[0-9]+).*$', '\1')
    ELSE NULL END
  AS "Accession #",
  -- 3 - Class 1 (fixed)
  'BIOLOGY' AS "Class 1",
  -- 4 - Kingdom (direct)
  kingdom AS "Kingdom",
  -- 5 - Phylum/Division (direct)
  phylum AS "Phylum/Division",
  -- 6 - Class (direct)
  phylclass AS "Class",
  -- 7 - Order (fixed)
  phylorder AS "Order",
  -- 8 - Family (fixed)
  family AS "Family",
  -- 9 - Sci. Name:Genus (split)
  genus AS "Sci. Name:Genus",
  -- 10 - Sci. Name:Species (split)
  -- CONCAT_WS(' ', species, infraspecific_rank, subspecies)
  CASE WHEN subspecies IS NULL
    THEN REPLACE(species, CONCAT(genus, ' '),'')
    ELSE REPLACE(subspecies, CONCAT(genus, ' '),'') END
    AS "Sci. Name:Species",
  -- 11 - Common Name (fixed)
  '' AS "Common Name",
  -- 12 - TSN (fixed)
  '' AS "TSN",
  -- 13 - Item Count (direct)
  1 AS "Item Count",
  -- 14 - Quantity (fixed)
  '' AS "Quantity",
  -- 15 - Storage Unit (fixed)
  'EA' AS "Storage Unit",
  -- 16 - Description (fixed)
  CONCAT(species, '; whole organism') AS "Description",
  -- 17 - Dimens/Weight (fixed)
  '' AS "Dimens/Weight",
  -- 18 - Collector (transform)
  UPPER(REGEXP_REPLACE(
    REGEXP_REPLACE(
      REGEXP_REPLACE(collectors, ',.*',''),
    '[A-Z]\.',''),
    '([^ ]+) +([^ ]+)', '\2, \1'))
    AS "Collector",
  -- 19 - Collection # (direct)
  CASE
    WHEN othercatalognumbers ~ 'collector number='
    THEN REGEXP_REPLACE(othercatalognumbers,
      '^.*collector number=([^,]+).*$', '\1')
    WHEN othercatalognumbers ~ 'field number='
    THEN REGEXP_REPLACE(othercatalognumbers,
      '^.*field number=([^,]+).*$', '\1')
    WHEN othercatalognumbers ~ 'other identifier='
    THEN REGEXP_REPLACE(othercatalognumbers,
      '^.*other identifier=([^,]+).*$', '\1')
    ELSE NULL END
  AS "Collection #",
  -- 20 - Collection Date (transform)
  TO_CHAR(ended_date::date, 'FMMM/FMDD/YYYY') AS "Collection Date",
  -- 21 - Condition (fixed)
  'COM/GD' AS "Condition",
  -- 22 - Condition Desc (fixed)
  '' AS "Condition Desc",
  -- 23 - Study # (fixed)
  '' AS "Study #",
  -- 24 - Other Numbers (combine)
  CONCAT_WS('', 'Arctos=', guid, 
  CASE WHEN othercatalognumbers ~ 'ALAAC'
    THEN CONCAT_WS('', ' ALAAC=', REGEXP_REPLACE(othercatalognumbers,
      '^.*ALAAC=([ABLV]?[0-9]+).*$', '\1'))
    ELSE NULL END
    ) AS "Other Numbers",
  -- 25 - Cataloger (transform)
  UPPER(REGEXP_REPLACE(
    REGEXP_REPLACE(
      REGEXP_REPLACE(enteredby, ',.*',''),
    '[A-Z]\.',''),
    '([^ ]+) +([^ ]+)', '\2, \1')) AS "Cataloger",
  -- 26 - Catalog Date (transform)
  TO_CHAR(entereddate::date, 'FMMM/FMDD/YYYY') AS "Catalog Date",
  -- 27 - Identified By (direct)
  UPPER(REGEXP_REPLACE(
    REGEXP_REPLACE(
      REGEXP_REPLACE(identifiedby, ',.*',''),
    '[A-Z]\.',''),
    '([^ ]+) +([^ ]+)', '\2, \1')) AS "Identified By",
  -- 28 - Ident Date (transform)
  TO_CHAR(made_date::date, 'FMMM/FMDD/YYYY') AS "Ident Date",
  -- 29 - Repro Method (fixed)
  '' AS "Repro Method",
  -- 30 - Locality (direct)
  verbatim_locality AS "Locality",
  -- 31 - Unit (fixed)
  '' AS "Unit",
  -- 32 - State (fixed)
  'AK' AS "State",
  -- 33 - Reference Datum (transform)
  CASE
    WHEN datum = 'World Geodetic System 1984' THEN 'WGS 84'
    WHEN datum = 'North American Datum 1927' THEN 'NAD 27'
    WHEN datum = 'North American Datum 1983' THEN 'NAD 83'
    ELSE NULL END
  AS "Reference Datum",
  -- 34 - Watrbody/Drain:Waterbody (fixed)
  '' AS "Watrbody/Drain:Waterbody",
  -- 35 - Watrbody/Drain:Drainage (fixed)
  '' AS "Watrbody/Drain:Drainage",
  -- 36 - UTM Z/E/N (fixed)
  '' AS "UTM Z/E/N",
  -- 37 - Lat LongN/W (combine)
  CONCAT_WS('', 'N', dec_lat, '/W',  REPLACE(dec_long::varchar,'-',''))
    AS "Lat LongN/W",
  -- 38 - Elevation (transform)
  CASE WHEN max_elev_in_m IS NOT NULL
    THEN CONCAT_WS('', max_elev_in_m, ' m')
  ELSE NULL END
  AS "Elevation",
  -- 39 - Depth (fixed)
  '' AS "Depth",
  -- 40 - Depos Environ (fixed)
  '' AS "Depos Environ",
  -- 41 - Habitat/Comm (fixed)
  '' AS "Habitat/Comm",
  -- 42 - Habitat (direct)
  habitat AS "Habitat",
  -- 43 - Slope (fixed)
  '' AS "Slope",
  -- 44 - Aspect (fixed)
  '' AS "Aspect",
  -- 45 - Soil Type (fixed)
  '' AS "Soil Type",
  -- 46 - For/Per/Sub (fixed)
  '' AS "For/Per/Sub",
  -- 47 - Assoc Spec (fixed)
  '' AS "Assoc Spec",
  -- 48 - Type Specimen (fixed)
  typestatus AS "Type Specimen",
  -- 49 - Threat/Endang (fixed)
  '' AS "Threat/Endang",
  -- 50 - T/E Date (fixed)
  '' AS "T/E Date",
  -- 51 - Rare (fixed)
  '' AS "Rare",
  -- 52 - Exotic/Native (fixed)
  '' AS "Exotic/Native",
  -- 53 - Age (fixed)
  '' AS "Age",
  -- 54 - Sex (fixed)
  '' AS "Sex",
  -- 55 - Notes (fixed)
  '' AS "Notes",
  -- 56 - Field Season
  TO_CHAR(ended_date::date, 'YYYY') AS "Field Season",
  -- 57 - Ctrl Prop (fixed)
  'N' AS "Ctrl Prop",
  -- 58 - Location (fixed)
  'UAMN - ALA HERBARIUM' AS "Location",
  -- 59 - Object Status (fixed)
  'LOAN OUT – NON-NPS – NON-FEDERAL' AS "Object Status",
  -- 60 - Status Date (fixed)
  '' AS "Status Date",
  -- 61 - Catalog Folder (fixed)
  'N' AS "Catalog Folder",
  -- 62 - Maint. Cycle (fixed)
  '' AS "Maint. Cycle"
FROM flat
WHERE REPLACE(REGEXP_REPLACE(othercatalognumbers,
      '^.*U\. S\. National Park Service catalog=([A-Z]+ *[0-9]+).*$', '\1'),
      ' ','') IN ('BELA56173','BELA56174','BELA56175','BELA56176','BELA56177','BELA56178','BELA56179','BELA56180','BELA56181','BELA56182','BELA56183','BELA56184','BELA56185','BELA56186','BELA56187','BELA56188','BELA56189','BELA56190','BELA56191','BELA56192','BELA56193','BELA56194','BELA56195','BELA56196','BELA56197','BELA56198','BELA56199','BELA56200','BELA56201','BELA56202','BELA56203','BELA56204','BELA56205','BELA56206','BELA56207','BELA56208','BELA56209','BELA56210','BELA56211','BELA56212','BELA56213','BELA56214','BELA56215','BELA56216','BELA56217','BELA56218','BELA56219','BELA56220','BELA56221','BELA56222','BELA56223','BELA56224','BELA56225','BELA56226','BELA56227','BELA56228','BELA56229','BELA56230','BELA56231','BELA56232','BELA56233','BELA56234','BELA56235','BELA56236','BELA56237','BELA56238','BELA56239','BELA56240','BELA56241','BELA56242','BELA56243','BELA56244','BELA56245','BELA56246','BELA56247','BELA56248','BELA56249','BELA56250','BELA56251','BELA56252','BELA56253','BELA56254','BELA56255','BELA56256','BELA56257','BELA56258','BELA56259','BELA56260','BELA56261','BELA56262','BELA56263','BELA56264','BELA56265','BELA56266','BELA56267','BELA56268','BELA56269','BELA56270','BELA56271','BELA56272','BELA56273','BELA56274','BELA56275','BELA56276','BELA56277','BELA56278','BELA56279','BELA56280','BELA56281','BELA56282','BELA56283','BELA56284','BELA56285','BELA56286','BELA56287','BELA56288','BELA56289','BELA56290','BELA56291','BELA56292','BELA56293','BELA56294','BELA56295','BELA56296','BELA56297','BELA56298','BELA56299','BELA56300','BELA56301','BELA56302','BELA56303','BELA56304','BELA56305','BELA56306','BELA56307','BELA56308','BELA56309','BELA56310','BELA56311','BELA56312','BELA56313','BELA56314','BELA56315','BELA56316','BELA56317','BELA56318','BELA56319','BELA56320','BELA56321','BELA56322','BELA56323','BELA56324','BELA56325','BELA56326','BELA56327','BELA56328','BELA56329','BELA56330','BELA56331','BELA56332','BELA56333','BELA56334','BELA56335','BELA56336','BELA56337','BELA56338','BELA56339','BELA56340','BELA56341','BELA56342','BELA56343','BELA56344','BELA56345','BELA56346','BELA56347','BELA56348','BELA56349','BELA56350','BELA56351','BELA56352','BELA56353','BELA56354','BELA56355','BELA56356','BELA56357','BELA56358','BELA56359','BELA56360','BELA56361','BELA56362','BELA56363','BELA56364','BELA56365','BELA56366','BELA56367','BELA56368','BELA56369','BELA56370','BELA56371','BELA56372','BELA56373','BELA56374','BELA56375','BELA56376','BELA56377','BELA56378','BELA56379','BELA56380','BELA56381','BELA56382','BELA56383','BELA56384','BELA56385','BELA56386','BELA56387','BELA56388','BELA56389','BELA56390','BELA56391','BELA56392','BELA56393','BELA56394','BELA56395','BELA56396','BELA56397','BELA56398','BELA56399','BELA56400','BELA56401','BELA56402','BELA56403','BELA56404','BELA56405','BELA56406','BELA56407','BELA56408','BELA56409','BELA56410','BELA56411','BELA56412','BELA56413','BELA56414','BELA56415','BELA56416','BELA56417','BELA56418','BELA56419','BELA56420','BELA56421','BELA56422','BELA56423','BELA56424','BELA56425','BELA56426','BELA56427','BELA56428','BELA56429','BELA56430','BELA56431','BELA56432','BELA56433','BELA56434','BELA56435','BELA56436','BELA56437','BELA56438','BELA56439','BELA56440','BELA56441','BELA56442','BELA56443','BELA56444','BELA56445','BELA56446','BELA56447','BELA56448','BELA56449','BELA56450','BELA56451','BELA56452','BELA56453','BELA56454','BELA56455','BELA56456','BELA56457','BELA56458','BELA56459','BELA56460','BELA56461','BELA56462','BELA56463','BELA56464','BELA56465','BELA56466','BELA56467','BELA56468','BELA56469','BELA56470','BELA56471','BELA56472','BELA56473','BELA56474','BELA56475','BELA56476','BELA56477','BELA56478','BELA56479','BELA56480','BELA56481','BELA56482','BELA56483','BELA56484','BELA56485','BELA56486','BELA56487','BELA56488','BELA56489','BELA56490','BELA56491','BELA56492','BELA56493','BELA56494','BELA56495','BELA56496','BELA56497','BELA56498','BELA56499','BELA56500','BELA56501','BELA56502','BELA56503','BELA56504','BELA56505','BELA56506','BELA56507','BELA56508','BELA56509','BELA56510','BELA56511','BELA56512','BELA56513','BELA56514','BELA56515','BELA56516','BELA56517','BELA56518','BELA56519','BELA56520','BELA56521','BELA56522','BELA56523','BELA56524','BELA56525','BELA56526','BELA56527','BELA56528','BELA56529','BELA56530','BELA56531','BELA56532','BELA56533','BELA56534','BELA56535','BELA56536','BELA56537','BELA56538','BELA56539','BELA56540','BELA56541','BELA56542','BELA56543','BELA56544','BELA56545','BELA56546','BELA56547','BELA56548','BELA56549','BELA56550','BELA56551','BELA56552','BELA56553','BELA56554','BELA56555','BELA56556','BELA56557','BELA56558','BELA56559','BELA56560','BELA56561','BELA56562','BELA56563','BELA56564','BELA56565','BELA56566','BELA56567','BELA56568','BELA56569','BELA56570','BELA56571','BELA56572','BELA56573','BELA56574','BELA56575','BELA56576','BELA56577','BELA56578','BELA56579','BELA56580','BELA56581','BELA56582','BELA56583','BELA56584','BELA56585','BELA56586','BELA56587','BELA56588','BELA56589','BELA56590','BELA56591','BELA56592','BELA56593','BELA56594','BELA56595','BELA56596','BELA56597','BELA56598','BELA56599','BELA56600','BELA56601','BELA56602','BELA56603','BELA56604','BELA56605','BELA56606','BELA56607','BELA56608','BELA56609','BELA56610','BELA56611','BELA56612','BELA56613','BELA56614','BELA56615','BELA56616','BELA56617','BELA56618','BELA56619','BELA56620','BELA56621','BELA56622','BELA56623','BELA56624','BELA56625','BELA56626','BELA56627','BELA56628','BELA56629','BELA56630','BELA56631','BELA56632','BELA56633','BELA56634','BELA56635','BELA56636','BELA56637','BELA56638','BELA56639','BELA56640','BELA56641','BELA56642','BELA56643','BELA56644','BELA56645','BELA56646','BELA56647','BELA56648','BELA56649','BELA56650','BELA56651','BELA56652','BELA56653','BELA56654','BELA56655','BELA56656','BELA56657','BELA56658','BELA56659','BELA56660','BELA56661','BELA56662','BELA56663','BELA56664','BELA56665','BELA56666')
ORDER BY guid ;

