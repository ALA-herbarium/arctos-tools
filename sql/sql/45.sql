-- GLOBAL TCN status

SELECT taxon, photo, locninfo, geo, count(*) from (
  SELECT
    -- NCBI families under Bryophyta
    CASE WHEN phylum = 'Bryophyta' OR family IN
('Amblystegiaceae', 'Ambuchananiaceae', 'Andreaeaceae',
'Andreaeobryaceae', 'Anomodontaceae', 'Aongstroemiaceae',
'Archidiaceae', 'Aulacomniaceae', 'Bartramiaceae', 'Brachytheciaceae',
'Braithwaiteaceae', 'Bruchiaceae', 'Bryaceae', 'Bryobartramiaceae',
'Bryoxiphiaceae', 'Buxbaumiaceae', 'Callicladiaceae',
'Calliergonaceae', 'Calymperaceae', 'Catagoniaceae', 'Catoscopiaceae',
'Climaciaceae', 'Cryphaeaceae', 'Daltoniaceae', 'Dicranaceae',
'Dicranellopsidaceae', 'Diphysciaceae', 'Disceliaceae',
'Ditrichaceae', 'Drummondiaceae', 'Echinodiaceae', 'Encalyptaceae',
'Entodontaceae', 'Erpodiaceae', 'Eustichiaceae', 'Fabroniaceae',
'Fissidentaceae', 'Flatbergiaceae', 'Flexitrichaceae',
'Fontinalaceae', 'Funariaceae', 'Gigaspermaceae', 'Grimmiaceae',
'Hedwigiaceae', 'Helicophyllaceae', 'Helodiaceae', 'Hookeriaceae',
'Hylocomiaceae', 'Hypnaceae', 'Hypnodendraceae', 'Hypodontiaceae',
'Hypopterygiaceae', 'Jocheniaceae', 'Lembophyllaceae',
'Leptodontaceae', 'Leptostomataceae', 'Lepyrodontaceae', 'Leskeaceae',
'Leucobryaceae', 'Leucodontaceae', 'Leucomiaceae', 'Meesiaceae',
'Meteoriaceae', 'Micromitriaceae', 'Mitteniaceae', 'Miyabeaceae',
'Mniaceae', 'Myriniaceae', 'Myuriaceae', 'Neckeraceae',
'Oedipodiaceae', 'Orthodontiaceae', 'Orthorrhynchiaceae',
'Orthostichellaceae', 'Orthotrichaceae', 'Phyllodrepaniaceae',
'Phyllogoniaceae', 'Pilotrichaceae', 'Plagiotheciaceae',
'Pleurophascaceae', 'Pleuroziopsidaceae', 'Polytrichaceae',
'Pottiaceae', 'Prionodontaceae', 'Pseudoditrichaceae',
'Pterigynandraceae', 'Pterobryaceae', 'Pterobryellaceae',
'Ptychomitriaceae', 'Ptychomniaceae', 'Pulchrinodaceae',
'Pylaisiaceae', 'Pylaisiadelphaceae', 'Racopilaceae',
'Regmatodontaceae', 'Rhabdoweisiaceae', 'Rhachitheciaceae',
'Rhacocarpaceae', 'Rhizogemmaceae', 'Rhizogoniaceae', 'Rhytidiaceae',
'Rigodiaceae', 'Roellobryaceae', 'Ruficaulaceae', 'Rutenbergiaceae',
'Saelaniaceae', 'Saulomataceae', 'Schimperobryaceae',
'Schistostegaceae', 'Scorpidiaceae', 'Scouleriaceae', 'Seligeriaceae',
'Sematophyllaceae', 'Serpotortellaceae', 'Sphagnaceae',
'Splachnaceae', 'Stereodontaceae', 'Stereophyllaceae',
'Symphyodontaceae', 'Takakiaceae', 'Taxiphyllaceae', 'Tetraphidaceae',
'Theliaceae', 'Thuidiaceae', 'Timmiaceae', 'Trachylomataceae') THEN 'moss'
      -- from doi:10.1639/0007-2745-119.4.361
      WHEN    family in
('Acarosporaceae', 'Andreiomycetaceae', 'Antennulariellaceae',
'Aphanopsidaceae', 'Arctomiaceae', 'Arthoniaceae', 'Arthopyreniaceae',
'Arthrorhaphidaceae', 'Atheliaceae', 'Baeomycetaceae',
'Biatorellaceae', 'Brigantieaceae', 'Caliciaceae', 'Cameroniaceae',
'Candelariaceae', 'Carbonicolaceae', 'Catillariaceae',
'Celotheliaceae', 'Chrysotrichaceae', 'Cladoniaceae', 'Clavulinaceae',
'Coccocarpiaceae', 'Coccotremataceae', 'Coenogoniaceae',
'Collemataceae', 'Coniocybaceae', 'Corticiaceae', 'Cystocoleaceae',
'Dacampiaceae', 'Dactylosporaceae', 'Elixiaceae', 'Fuscideaceae',
'Gloeoheppiaceae', 'Gomphillaceae', 'Graphidaceae', 'Gyalectaceae',
'Gypsoplacaceae', 'Haematommataceae', 'Helocarpaceae',
'Hygrophoraceae', 'Hymeneliaceae', 'Icmadophilaceae', 'Incertae',
'Koerberiaceae', 'Lecanographaceae', 'Lecanoraceae', 'Lecideaceae',
'Lepidostromataceae', 'Leprocaulaceae', 'Letrouitiaceae',
'Lichinaceae', 'Lobariaceae', 'Lopadiaceae', 'Lyrommataceae',
'Malmideaceae', 'Massalongiaceae', 'Megalosporaceae', 'Megasporaceae',
'Melaspileaceae', 'Microtheliopsidaceae', 'Miltideaceae',
'Monoblastiaceae', 'Mycoporaceae', 'Mycosphaerellaceae',
'Nephromataceae', 'Ochrolechiaceae', 'Opegraphaceae',
'Ophioparmaceae', 'Pachyascaceae', 'Pannariaceae', 'Parmeliaceae',
'Peltigeraceae', 'Peltulaceae', 'Pertusariaceae', 'Phlyctidaceae',
'Physciaceae', 'Pilocarpaceae', 'Placynthiaceae', 'Porinaceae',
'Protothelenellaceae', 'Psilolechiaceae', 'Psoraceae', 'Pycnoraceae',
'Pyrenotrichaceae', 'Pyrenulaceae', 'Racodiaceae', 'Ramalinaceae',
'Ramboldiaceae', 'Requienellaceae', 'Rhizocarpaceae', 'Roccellaceae',
'Roccellographaceae', 'Ropalosporaceae', 'Sagiolechiaceae',
'Sarrameanaceae', 'Schaereriaceae', 'Scoliciosporaceae',
'Sphaerophoraceae', 'Sporastatiaceae', 'Stereocaulaceae',
'Stictidaceae', 'Strangosporaceae', 'Strigulaceae', 'Teloschistaceae',
'Tephromelataceae', 'Thelenellaceae', 'Thelocarpaceae',
'Thrombiaceae', 'Trapeliaceae', 'Trypetheliaceae', 'Umbilicariaceae',
'Vahliellaceae', 'Verrucariaceae', 'Vezdaeaceae', 'Xanthopyreniaceae',
'Xylographaceae') THEN 'lichen'
      ELSE 'other' END
      AS taxon,
    CASE WHEN imageurl IS NOT NULL THEN 'yes'
      ELSE 'no' END
      AS photo,
    CASE WHEN dec_lat IS NOT NULL THEN 'yes'
      ELSE 'no' END
      AS geo,
    CASE 
      WHEN spec_locality !~ 'No specific locality recorded.'
      AND spec_locality !~ 'Unknown, North America'
      AND spec_locality !~ 'unknown'
    THEN 'yes' ELSE 'no' END
    AS locninfo
  FROM flat
  WHERE
    guid ~ 'UAMb:Herb' 
) AS A
GROUP BY taxon, photo, locninfo, geo
ORDER BY taxon, photo, locninfo, geo

