-- Specimen label, legacy ala_Label

select
case flat.state_prov when 'Yukon Territory' then 'YUKON T.'
else
upper(flat.state_prov) end
 ||
case flat.country when 'United States' then
', USA'
else
', ' || upper(flat.country) end as geog,
flat.FORMATTED_SCIENTIFIC_NAME	sci_name_with_auth,
flat.IDENTIFIEDBY identified_by,
 flat.family,
flat.scientific_name tsname,
flat.author_text auth,
flat.attributes,
trim(ConcatAttributeValue(flat.collection_object_id,'abundance')) abundance,
identification.identification_remarks,
flat.made_date,
flat.cat_num,
flat.state_prov,
flat.country,
flat.quad,
flat.county,
flat.island,
flat.island_group,
flat.sea,
flat.feature,
flat.spec_locality,
flat.verbatim_coordinates Coordinates,
		flat.MAXIMUM_ELEVATION,
		flat.MINIMUM_ELEVATION,
		flat.ORIG_ELEV_UNITS,
		 flat.collectors,
		 flat.OTHERCATALOGNUMBERS,
		concatsingleotherid(flat.collection_object_id,'original identifier') fieldnum,
		concatsingleotherid(flat.collection_object_id,'U. S. National Park Service accession') npsa,
		concatsingleotherid(flat.collection_object_id,'U. S. National Park Service catalog') npsc,
		concatsingleotherid(flat.collection_object_id,'ALAAC') ALAAC,
		flat.verbatim_date,
		flat.habitat,
		flat.associated_species,
		project_name
	FROM
		flat
inner join identification on flat.identification_id=identification.identification_id and identification.accepted_id_fg=1
left outer join project_trans on flat.accn_id = project_trans.transaction_id
left outer join project on project_trans.project_id = project.project_id
where
flat.collection_object_id in (#collection_object_id#)
order by concatsingleotherid(flat.collection_object_id,'original identifier')
