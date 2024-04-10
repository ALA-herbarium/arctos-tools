# SQL queries

 * **Admin**
    * Admin, most active days and table edits, list, sort by number of specimens updated [[07.sql](sql/07.sql)]
    * Admin, recent edits to specimens, list, for username (Q1) [[05.sql](sql/05.sql)]
    * Admin, recent edits to specimens, summarize bu user and guid [[43.sql](sql/43.sql)]
 * **Attributes**
    * Attributes, list, using flat [[59.sql](sql/59.sql)]
 * **Barcode**
    * Barcode, and container, query on catalog number [[09.sql](sql/09.sql)]
 * **Barcodes**
    * Barcodes, which are herbarium sheets w/o contents but with parents (= error) [[64.sql](sql/64.sql)]
 * **Cabinets**
    * Cabinets, ALA, in Room 009, by Range [[65.sql](sql/65.sql)]
 * **Containers**
    * Containers [[36.sql](sql/36.sql)]
    * Containers, major, in Rooms 003, 018, 040 [[66.sql](sql/66.sql)]
 * **Digitization progress**
    * Digitization progress, by phylum, by time period of date entered (see also 41.sql) [[40.sql](sql/40.sql)]
    * Digitization progress, by phylum, by time period of new media added (see also 40.sql) [[41.sql](sql/41.sql)]
    * Digitization progress, for N, Central and S Amercia  [[11.sql](sql/11.sql)]
 * **Duplicate entries for single specimen**
    * Duplicate entries for single specimen, by ALAAC [[12.sql](sql/12.sql)]
    * Duplicate entries for single specimen, by ALAAC, showing some fields [[33.sql](sql/33.sql)]
    * Duplicate entries for single specimen, by Barcode [[34.sql](sql/34.sql)]
 * **GLOBAL TCN status**
    * GLOBAL TCN status [[45.sql](sql/45.sql)]
 * **GUID**
    * GUID, find from barcode in media URL [[38.sql](sql/38.sql)]
    * GUID, from barcode, not using flat json [[62.sql](sql/62.sql)]
    * GUID, from list of ALAACs [[57.sql](sql/57.sql)]
    * GUID, from list of ALAACs, using flat only [[58.sql](sql/58.sql)]
 * **GUIDs**
    * GUIDs, where the is no attribute [[60.sql](sql/60.sql)]
 * **Identifications**
    * Identifications, for a list of GUIDs [[25.sql](sql/25.sql)]
    * Identifications, for a list of GUIDs, filtered by date for that GUID [[26.sql](sql/26.sql)]
 * **Identifiers**
    * Identifiers, ALAAC, cases of duplicates caused by internal leading zeros [[37.sql](sql/37.sql)]
 * **Info**
    * Info, columns in a table [[50.sql](sql/50.sql)]
    * Info, explore diff between made_date and date_made_date [[32.sql](sql/32.sql)]
    * Info, fields in `flat`, list all [[02.sql](sql/02.sql)]
    * Info, find possible table from column_name [[51.sql](sql/51.sql)]
    * Info, tables in ArctosDB, list all [[03.sql](sql/03.sql)]
 * **Information**
    * Information, count of ALAAC identifiers which occur on 2 or more records! [[56.sql](sql/56.sql)]
 * **Localities**
    * Localities, list changes, for a locality_id (Q1) [[08.sql](sql/08.sql)]
    * Localities, list, sort by most specimens, UAM:Herb [[04.sql](sql/04.sql)]
    * Localities, list, sort by most specimens, UAMb:Herb [[04b.sql](sql/04b.sql)]
 * **Media**
    * Media, all, with barcode and Guid [[35.sql](sql/35.sql)]
 * **Part attribute**
    * Part attribute, location, list only the most recent for an object [[61.sql](sql/61.sql)]
 * **Parts**
    * Parts, all in ROOM20, using just flat [[63.sql](sql/63.sql)]
 * **SQL tricks**
    * SQL tricks, creating a temporary table with CREATE [[52.sql](sql/52.sql)]
 * **Scientific names**
    * Scientific names, in ALA, with more than 1 classification in Arctos Plants [[49.sql](sql/49.sql)]
    * Scientific names, without any classification elements [[48.sql](sql/48.sql)]
    * Scientific names, without classification elements, tested via family [[46.sql](sql/46.sql)]
 * **Specimen count**
    * Specimen count, by Herb sub-collection [[01.sql](sql/01.sql)]
    * Specimen count, in Asia, with locality but not georeferenced [[31.sql](sql/31.sql)]
    * Specimen count, no geographic information at all [[30.sql](sql/30.sql)]
    * Specimen count, per genus, per continent (for Trees TCN, Feb 2022) [[22.sql](sql/22.sql)]
    * Specimen count, within time range, for taxonomic class [[20.sql](sql/20.sql)]
    * Specimen count, within time range, for taxonomic class, summarized for different levels of digitization (depreciated, see 40.sql) [[21.sql](sql/21.sql)]
 * **Specimen details from a list of GUIDs**
    * Specimen details from a list of GUIDs [[10.sql](sql/10.sql)]
 * **Specimen label**
    * Specimen label, legacy ala_Label [[42.sql](sql/42.sql)]
 * **Specimens**
    * Specimens, all NPS specimens, listing key data [[15.sql](sql/15.sql)]
    * Specimens, all, for an accession, key identifier fields [[13.sql](sql/13.sql)]
    * Specimens, all, summary of key data elements for ALA barcode checker [[44.sql](sql/44.sql)]
    * Specimens, broad search by park including park name and geography [[18.sql](sql/18.sql)]
    * Specimens, for list of GUIDs, show barcodes [[24.sql](sql/24.sql)]
    * Specimens, from a list of ALAAC/GUID numbers, return primary info fields [[14.sql](sql/14.sql)]
    * Specimens, from a list of GUID numbers, return all fields for export to NPS [[27.sql](sql/27.sql)]
    * Specimens, from a list of GUID numbers, return fields for NPS checking [[23.sql](sql/23.sql)]
    * Specimens, from a list of NPS Catalog #s, return all fields for nacompare [[29.sql](sql/29.sql)]
    * Specimens, having more than one ALAAC identifier [[55.sql](sql/55.sql)]
    * Specimens, list bryophytes with photos, but needing transcription [[47.sql](sql/47.sql)]
    * Specimens, photos but no transcribed data, return GUID, barcode, Media URL [[19.sql](sql/19.sql)]
    * Specimens, query on barcode [[16.sql](sql/16.sql)]
    * Specimens, return identifiers searching on ALAAC (NPS project) [[54.sql](sql/54.sql)]
    * Specimens, return identifiers searching on NPS cat num (NPS project) [[53.sql](sql/53.sql)]
    * Specimens, total count, for time period, from Russia [[28.sql](sql/28.sql)]
    * Specimens, total count, from Russia, with image during time period [[39.sql](sql/39.sql)]
    * Specimens, with a NPS catalog number, total count [[06.sql](sql/06.sql)]
    * Specimens, within a National Park, but with no NPS Catalog code [[17.sql](sql/17.sql)]

