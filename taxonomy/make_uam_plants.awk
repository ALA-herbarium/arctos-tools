BEGIN{

  print "reading Arctos taxa" > "/dev/stderr"
  while (getline<"arctos_names")
    arctos[$0]
  
  print "reading WFO" > "/dev/stderr"
  FS="\t"
  OFS=","
  # header
  getline < "classification.csv"
  for (i = 1; i <= NF; i++)
    f[$i] = i
  while (getline<"classification.csv") {
    clean()
    if ((++rep % 1000) == 0)
      printf "line %6.0d  %6.0d\r", rep, found > "/dev/stderr"
    if (gensub(/"/,"","G",$f["scientificName"]) in arctos) {
      found++
      #if (found > 100)
      #  break
      n[$f["scientificName"]]++
      if (maxn < n[$f["scientificName"]])
        maxn = n[$f["scientificName"]]
      # wfo ID
      d[$f["scientificName"]][n[$f["scientificName"]]]["wfo"] = \
        $f["taxonID"]
      # lookup
      wfo[$f["taxonID"]] = ($f["scientificNameAuthorship"] ?   \
                            ($f["scientificName"] " "          \
                             $f["scientificNameAuthorship"]) : \
                            $f["scientificName"])
      # status
      d[$f["scientificName"]][n[$f["scientificName"]]]["status"] =  \
        $f["taxonomicStatus"]
      # status
      d[$f["scientificName"]][n[$f["scientificName"]]]["acceptedWFO"]   \
        = $f["acceptedNameUsageID"]
      # author
      d[$f["scientificName"]][n[$f["scientificName"]]]["author"] =  \
        $f["scientificNameAuthorship"]
      # family
      d[$f["scientificName"]][n[$f["scientificName"]]]["family"] =  \
        $f["family"]
      # genus
      d[$f["scientificName"]][n[$f["scientificName"]]]["genus"] = \
        $f["genus"]
      # species
      d[$f["scientificName"]][n[$f["scientificName"]]]["species"] = \
        $f["specificEpithet"]
      # subspecies
      if ($f["taxonRank"] == "subspecies") 
        d[$f["scientificName"]][n[$f["scientificName"]]]["subsp"] = \
          $f["infraspecificEpithet"]
      # variety
      if ($f["taxonRank"] == "variety") 
        d[$f["scientificName"]][n[$f["scientificName"]]]["var"] = \
          $f["infraspecificEpithet"]
      # forma
      if ($f["taxonRank"] == "form") 
        d[$f["scientificName"]][n[$f["scientificName"]]]["forma"] = \
          $f["infraspecificEpithet"]
      # TODO check for infra ranks other than subsp, var, f in both
      # WFO and arctos
    }
  }
  print "" > "/dev/stderr"

  # make bulkloader file header first: name, arctos_source,
  # hierarchical terms, for all: kingdom, phylum, fam, genus, species,
  #   subsp, var, forma = 8
  ORS="\r"
  header =                            \
    "scientific_name,source,"         \
    "class_term_type_1,class_term_1," \
    "class_term_type_2,class_term_2," \
    "class_term_type_3,class_term_3," \
    "class_term_type_4,class_term_4," \
    "class_term_type_5,class_term_5," \
    "class_term_type_6,class_term_6," \
    "class_term_type_7,class_term_7," \
    "class_term_type_8,class_term_8"
  # WFO
  header = header ",noclass_term_type_1,noclass_term_1"
  h = 1
  # compute number of extra terms:
  # fullname, wfoID, status, synonym_of_wfo, synonym_of_name
  for (i = 1; i <= maxn; i++)
    for (j = 1; j <= 5; j++)
      header = header                                 \
        ",noclass_term_type_" ++h ",noclass_term_" h
  
  gsub(/,$/,"",header)
  print header
  
  PROCINFO["sorted_in"] = "@ind_str_asc"
  for (i in d) {
    # use the hierarchical classification from #1
    line = i ",UAM Plants"                                              \
      ",kingdom,Plantae"                                                \
      ",phylum,Tracheophyta"                                            \
      ",family,"      d[i][1]["family"]                                 \
      ",genus,"      d[i][1]["genus"]                                   \
      ",species,"    ((d[i][1]["species"]) ?                            \
                      (d[i][1]["genus"] " " d[i][1]["species"]) : "")   \
      ",subspecies," ((d[i][1]["subsp"]) ?                              \
                      (d[i][1]["genus"] " " d[i][1]["species"] " subsp. " \
                       d[i][1]["subsp"]):"")                            \
      ",variety,"    ((d[i][1]["var"]) ?                                \
                      (d[i][1]["genus"] " " d[i][1]["species"] " var. " \
                       d[i][1]["var"]):"")                              \
      ",forma,"      ((d[i][1]["forma"]) ?                              \
                      (d[i][1]["genus"] " " d[i][1]["species"] " f. " \
                       d[i][1]["forma"]):"")                          \
      ",classification source,v.2023.12 2023-12-22"
    # for each variation in author, 5 things
    for (j = 1; j <= maxn; j++)
      line = line ","                                                   \
        j "_fullname,\""  (d[i][j]["author"] ? (i " " d[i][j]["author"]) : i) \
        "\","                                                           \
        j "_wfoID,"      d[i][j]["wfo"] ","                             \
        j "_status,"     d[i][j]["status"] ","                          \
        j "_synonym_of_wfoID," d[i][j]["acceptedWFO"] ","               \
        j "_synonym_of_name,\"" wfo[d[i][j]["acceptedWFO"]] "\""
    print line
  }
}

function clean(   i) {
  for (i = 1; i < NF; i++) {
    gsub(/^"/,"",$i)
    gsub(/"$/,"",$i)
    gsub(/""/,"\"",$i)
    gsub(/\|/,"^",$i)
  }
}
