BEGIN{

  print "reading Arctos taxa" > "/dev/stderr"
  FS=","
  while (getline<"arctos_names")
    #  WFO has a space before the ×
    arctos[gensub(/×([^ ])/,"× \\1","G",$1)] = $2 
  
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
    # lookup (outside the Arctos set)
    wfo[$f["taxonID"]] = ($f["scientificNameAuthorship"] ?     \
                          ($f["scientificName"] " "            \
                           $f["scientificNameAuthorship"]) :   \
                          $f["scientificName"])
    if (gensub(/"/,"","G",$f["scientificName"]) in arctos) {
      found++
      # if (found > 100)
      #  break
      if (maxn < ++n[$f["scientificName"]])
        maxn = n[$f["scientificName"]]
      # wfo ID
      d[$f["scientificName"]][n[$f["scientificName"]]]["wfo"] = \
        $f["taxonID"]
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

  if (BULKLOADER) {
    # make bulkloader file header first: name, arctos_source,
    # hierarchical terms, for all: kingdom, phylum, fam, genus, species,
    #   subsp, var, forma = 8
    ORS="\r"
    header =                          \
      "scientific_name,source,"       \
      "class_term_type_1,class_term_1,"         \
      "class_term_type_2,class_term_2," \
      "class_term_type_3,class_term_3," \
      "class_term_type_4,class_term_4," \
      "class_term_type_5,class_term_5," \
      "class_term_type_6,class_term_6," \
      "class_term_type_7,class_term_7," \
      "class_term_type_8,class_term_8"
    # WFO, managed by
    header = header ",noclass_term_type_1,noclass_term_1" \
      ",noclass_term_type_2,noclass_term_2"
    h = 2
    # compute number of extra terms:
    # fullname, wfoID, status, synonym_of_wfo, synonym_of_name
    for (i = 1; i <= maxn; i++)
      for (j = 1; j <= 5; j++)
        header = header                                 \
          ",noclass_term_type_" ++h ",noclass_term_" h
    print header
  
    PROCINFO["sorted_in"] = "@ind_str_asc"
    for (i in d) {
      # use the hierarchical classification from #1
      #  Arctos has no space before the ×
      line = gensub(/× +/,"×","G",i) ",UAM Plants"                        \
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
                        (d[i][1]["genus"] " " d[i][1]["species"] " f. "   \
                         d[i][1]["forma"]):"")                            \
        ",classification source,World Flora Online v.2023.12"             \
        ",managed_by,camwebb@Arctos"
      # for each variation in author, 5 things
      for (j = 1; j <= maxn; j++)
        line = line ","                                                   \
          j "_fullname,\""  (d[i][j]["wfo"] ? (d[i][j]["author"] ? \
                                               (i " " d[i][j]["author"]) : i) \
                             : "")                                        \
          "\","                                                           \
          j "_wfoID,"      d[i][j]["wfo"] ","                             \
          j "_status,"     d[i][j]["status"] ","                          \
          j "_synonym_of_wfoID," d[i][j]["acceptedWFO"] ","               \
          j "_synonym_of_name,\"" wfo[d[i][j]["acceptedWFO"]] "\""
      print line
    }
  }
  else {
    # $ sqlite3 test.db
    # > CREATE TABLE taxon_term (taxon_name_id INTEGER, source TEXT,
    #   classification_id TEXT, term_type TEXT, position_in_classification
    #   INTEGER, term TEXT, UNIQUE(taxon_name_id,source,term_type));
    # $ cat classification_bulkloader.sql | sqlite3 test.db
    # > SELECT * FROM taxon_term
    
    sql = "INSERT INTO taxon_term (taxon_name_id, source,\n"\
      "classification_id, term_type, position_in_classification, term) VALUES"
    print sql

    "uuidgen" | getline uuid
    PROCINFO["sorted_in"] = "@ind_str_asc"
    
    for (i in d) {
      suffix = "),"
      # use the hierarchical classification from #1
      #  Arctos has no space before the ×
      prefix = "  (" arctos[gensub(/× +/,"×","G",i)] ", 'UAM Plants', '" \
        substr(uuid,1,13) sprintf("-%05d", ++u) "',\n    "
      print prefix "1, 'kingdom', 'Plantae'" suffix
      print prefix "2, 'phylum', 'Tracheophyta'" suffix
      print prefix "3, 'family', '"  d[i][1]["family"] "'" suffix
      print prefix "4, 'genus', '"   d[i][1]["genus"]  "'" suffix
      print prefix "5, 'species', "                                      \
        ((d[i][1]["species"]) ? ("'" d[i][1]["genus"] " " d[i][1]["species"] \
                                     "'" ) : "NULL") suffix
      print prefix "6, 'subspecies', "                                   \
        ((d[i][1]["subsp"]) ? ("'" d[i][1]["genus"] " " d[i][1]["species"] \
                               " subsp. " d[i][1]["subsp"] "'") : "NULL") suffix
      print prefix "7, 'variety', " \
        ((d[i][1]["var"]) ? ("'" d[i][1]["genus"] " " d[i][1]["species"] \
                             " var. " d[i][1]["var"] "'"):"NULL") suffix

      print prefix "8, 'forma', "                                      \
        ((d[i][1]["forma"]) ? ("'" d[i][1]["genus"] " " d[i][1]["species"] \
                               " f. " d[i][1]["forma"] "'") : "NULL") suffix
      #
      print prefix "NULL ,'classification source', 'World Flora Online v.2023.12'" \
        suffix
      print prefix "NULL ,'managed_by', 'camwebb@Arctos'" suffix

      # for each variation in author, 5 things
      for (j = 1; j <= n[i]; j++) {
        print prefix "NULL ,'" j "_fullname','"                                \
          (d[i][j]["author"] ? (i " "  d[i][j]["author"]) : i ) "'" suffix
        print prefix "NULL ,'" j "_wfoID','https://worldfloraonline.org/taxon/" \
          d[i][j]["wfo"] "'" suffix
        print prefix "NULL ,'" j "_status','" d[i][j]["status"] "'" suffix
        print prefix "NULL ,'" j "_synonym_of_wfoID'," \
          (d[i][j]["acceptedWFO"] ? ("'" d[i][j]["acceptedWFO"] "'") : "NULL") \
          suffix
        
        # check for need to set a new INSERT
        if ((++vals % 10) == 0 || u == length(d))
          suffix = ");\n"
      
        print prefix "NULL ,'" j "_synonym_of_name'," \
          (wfo[d[i][j]["acceptedWFO"]] ? ("'" wfo[d[i][j]["acceptedWFO"]] "'")\
           : "NULL") suffix
        
        if ((vals % 10) == 0 && u < length(d)) {
          print sql
          suffix = "),"
        }
      }
    }
  }
}

function clean(   i) {
  for (i = 1; i < NF; i++) {
    gsub(/^"/,"",$i)
    gsub(/"$/,"",$i)
    gsub(/""/,"\"",$i)
    gsub(/""/,"\"",$i)
    # for SQL:
    if (!BULKLOADER)
      gsub(/'/,"''",$i)
  }
}
