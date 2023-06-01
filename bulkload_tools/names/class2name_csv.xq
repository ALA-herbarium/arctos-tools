"scientific_name,name_type",

for $r in //record
return
  concat(
    $r/name/string(),
    ",Linnean"
    )
