-- Specimens, lichens, by collection year

SELECT year, COUNT(*)
  from flat
  WHERE family in
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
'Xylographaceae') AND 
  guid_prefix = 'UAMb:Herb' 
GROUP BY year
ORDER BY year
LIMIT 10


