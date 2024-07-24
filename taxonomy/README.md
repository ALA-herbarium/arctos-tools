# Making the UAM Plants classification from WFO

Identifications in Arctos are to names, which (without the use of `A
{string}`, see
[issue 7962](https://github.com/ArctosDB/arctos/issues/7962)) do not
specify the author string. Some name-author combinations are accepted,
some are synonyms. In order to manage synonymy using up-to-date
resources, we can load the name variations into a classification,
which can be easily updated.  For plants at ALA we are switching from
the Arctos Plants classification to a new UAM Plants classification
(in first slot of the classification sources). Currently this only
contains information for the vascular plants at the World Flora
online. In the future we will add cryptogam and lichen name sources.

## Steps

Make a list of Arctos ALA names using:

```sql
SELECT DISTINCT scientific_name FROM flat 
WHERE guid_prefix in ('UAM:Herb', 'UAM:Alg', 'UAM:Myco', 'UAMb:Herb')
```

and save as `arctos_names`

Download the latest WFO:

```bash
curl -L https://files.worldfloraonline.org/files/WFO_Backbone/_WFOCompleteBackbone/WFO_Backbone.zip > WFO_Backbone.zip
unzip WFO_Backbone.zip
```

Convert:

```bash
gawk -f make_uam_plants.awk > classification_bulkloader.csv
cat classification_bulkloader.csv | tr "\r" "\n" | wc -l # 9766 lines
```

<!-- original test:
1_author_text: C.B.Clarke
1_full_name: Erigeron acris C.B.Clarke
1_synonym_of_arctos: Erigeron pulchellus
1_synonym_of_full: Erigeron pulchellus Michx.
1_synonym_of_wfo: wfo-0000009039
1_taxon_status: synonym
1_wfo: wfo-0000067521
2_author_text: L.
2_full_name: Erigeron acris L.
2_taxon_status: accepted
2_wfo: wfo-0000085388
managed_by: camwebb@Arctos
source_authority: World Flora Online Plant List 2023-12
synonym_of: Erigeron pulchellus
Classification:
Plantae (kingdom)
Pteridobiotina (subkingdom)
Angiosperms (phylum)
Asterales (order)
Asteraceae (family)
Asteroideae (subfamily)
Astereae (tribe)
Conyzinae (subtribe)
Erigeron (genus)
Erigeron acris (species) 
-->
