"scientific_name,source,noclass_term_type_1,noclass_term_1,noclass_term_type_2,noclass_term_2,noclass_term_type_3,noclass_term_3,noclass_term_type_4,noclass_term_4,noclass_term_type_5,noclass_term_5,class_term_type_1,class_term_1,class_term_type_2,class_term_2,class_term_type_3,class_term_3,class_term_type_4,class_term_4,class_term_type_5,class_term_5,class_term_type_6,class_term_6,class_term_type_7,class_term_7,class_term_type_8,class_term_8",

for $r in //record
return
  concat(
    $r/name/string(),
    ",",
    $r/source/string(),
    ",",
    string-join(
      for $n in 1 to 5
      return
        concat(
          $r/nct[@n = $n]/@type/string(), ",",
          $r/nct[@n = $n]/string()
        ) ,
        ","
    ),
    ",",
    string-join(
      for $n in 1 to 8
      return
        concat(
          $r/ct[@n = $n]/@type/string(), ",",
          $r/ct[@n = $n]/string()
        ) ,
        ","
    )

  )