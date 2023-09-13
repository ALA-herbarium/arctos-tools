# Batch creating taxonomic names and classifications

 * During the bulk upload testing phase you will generate a list of
   taxonomic names that do no match those in Arctos.
 * Use the 


 * Go to the GNI [web page](https://gni.globalnames.org/) and paste in
   the list of names. Select JSON as the output format. In the
   Advanced section, select only: IPNI, Tropicos and WFO. Run the
   query and save the result as `4_gni.json` (Note, this GNI query
   could be automated via some basic calls to the GNI API. To do?)


 * Clean-up:
    * Check each record in the XML file. Edit as needed.
    * If the name is not found automatically, search more widely in
      other names resources (using GNI). If still not found, but name
      seems useful to add, use ‘ALA herbarium’ as the authority and
      add it anyway.
    * You may need to edit the bulkload import name to match either
      existing Arctos names or a new name.

xqilla -i classification.xml class2names.xq > name.csv 

xqilla -i classification.xml class2csv.xq > class.csv 

Don't forget to convert to Mac before uploading.
