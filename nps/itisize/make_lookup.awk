BEGIN{
  FS=OFS="|"
  while (getline < "taxon_unit_types")
    ranktype[$2]=$3
  
  print "loading authors" > "/dev/stderr"

  while (getline < "taxon_authors")
    astr[$1] = $2
  
  print "loading vernaculars" > "/dev/stderr"

  while (getline < "vernaculars")
    if ($3 == "English")
      common[$1] = $2
  
  print "loading taxa" > "/dev/stderr"
  
  while (getline < "taxonomic_units") {
    if ($21 == 3) {
      if ($2)
        xgen[$1] = "×"
      gen[$1] = $3
      if ($4)
        xsp[$1] = "×"
      sp[$1] = $5
      ir[$1] = $6
      is[$1] = $7
      auth[$1] = astr[$19]
      up[$1] = $18
      rank[$1] = ranktype[$22]
      if ($11 == "accepted")
        acc[$1] = 1
      if (rank[$1] == "Genus")
        togen[gen[$1]] = $1
    }
  }

  print "proc. accepted taxa" > "/dev/stderr"

  # for accepteds
  for (i in gen) {
    if (!acc[i])
      continue
    at = i
    atrank = rank[i]
    while (at) {
      at = up[at]
      atrank = rank[at]
      if (atrank == "Family")
        Fam[i] = gen[at]
      if (atrank == "Order")
        Ord[i] = gen[at]
      if (atrank == "Class")
        Class[i] = gen[at]
      if (atrank == "Phylum")
        Phylum[i] = gen[at]
    }
  }

  print "proc. non-accepted taxa" > "/dev/stderr"

  # fill in the tree for non-accepteds
  
  for (i in gen) {
    if (acc[i])
      continue
    Fam[i] = Fam[togen[gen[i]]]
    Ord[i] = Ord[togen[gen[i]]]
    Class[i] = Class[togen[gen[i]]]
  }
  
  for (i in gen)
    if (rank[i] ~ /^(Species|Subspecies|Variety|Subvariety|Form|Subform)$/)
      print xgen[i], gen[i], xsp[i], sp[i], ir[i], is[i], auth[i], i, acc[i], rank[i], Fam[i], Ord[i], Class[i] , Phylum[i], "Plantae", common[i]
  
}
