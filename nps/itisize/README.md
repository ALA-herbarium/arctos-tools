# itisize - add TSN to Arctos output

## Create lookup table

 * From ITIS get `../itisMySQLTables.tar.gz`
 * Extract: `taxon_unit_types`, `taxon_authors_lkp`, `vernaculars`,
   `taxonomic_units`
 * Change encoding: `iconv -f LATIN1 -t UTF-8 taxon_authors_lkp > taxon_authors`
 * Run `gawk -f make_lookup.awk | sort > itis`
 
 

