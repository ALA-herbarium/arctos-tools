BEGIN{
  RS="\r"
  FS=","

  # header
  getline<"uam_plants.csv"
  for (i = 1; i <= NF; i++)
    header[i] = $i
  f = NF
  print "fields: " NF > "/dev/stderr"
  
  # first line
  # take a risk on there being a comma inside a name field
  getline<"uam_plants.csv"
  for (i = 3; i <= NF; i+=2)
    field[i] = $i

  # all lines
  while(getline<"uam_plants.csv")
    name[$1]

  # print header
  for (i = 1; i < f; i++)
    printf "%s," , header[i]
  printf "status\n"

  for (i in name) {
    printf "%s,UAM Plants,", i
    for (j = 3; j < f; j+=2)
      printf "%s,,", field[j]
    printf "autoload\n"
  }
}
    
