class ItemMetadata < ActiveFedora::OmDatastream

	#set_terminology do |t|
	#	t.root(path: "fields")
	#	t.title
	#	t.author
	#end
	
	set_terminology do |t|
		t.root(path: "mods")
		
		t.title_info(path: "titleInfo") {
			t.title(path: "title", index_as: :stored_searchable)
			t.sub_title(path: "subTitle", index_as: :stored_searchable)
			t.part_number(path: "partNumber")
			t.part_name(path: "partName")
			t.non_sort(path: "nonSort", index_as: :stored_searchable)
		}
		t.name(path: "name") {
			t.name_part(path: "namePart", index_as: :stored_searchable)
			t.affiliation(path: "affiliation")
			t.role(path: "role") {
				t.role_term(path: "roleTerm")
			}
		}
		t.type_of_resource(path: "typeOfResource")
		t.genre(path: "genre", index_as: :facetable)
		t.origin_info(path: "originInfo") {
			t.place(path: "place") {
				t.place_term(path: "placeTerm")
			}
			t.publisher(path: "publisher")
			t.date_issued(path: "dateIssued")
			t.date_created(path: "dateCreated")
			t.copyright_date(path: "copyrightDate")
			t.date_other(path: "dateOther")
			t.edition(path: "edition")
			t.issuance(path: "issuance")
			t.frequency(path: "frequency")
		}
		t.language(path: "language") {
			t.language_term(path: "languageTerm")
		}
		t.physical_description(path: "physicalDescription") {
			t.internet_media_type(path: "internetMediaType")
			t.extent(path: "extent")
			t.digital_origin(path: "digitalOrigin")
			t.note(path: "note")
		}
		t.abstract(path: "abstract")
		t.table_of_contents(path: "tableOfContents")
		#t.note(path: "note")
		t.general_note(:path=>"note", attributes: {type: "general"})
		t.preferred_citation(:path=>"note", attributes: {type: "preferred citation"})
		t.biographical(:path=>"note", attributes: {type: "biographical"})
		t.note(:path=>"note") {
			t.type_at(:path=>{:attribute=>"type"})
		}
		t.subject(path: "subject") {
			t.topic(path: "topic", index_as: :facetable)
			t.geographic(path: "geographic")
			t.temporal(path: "temporal")
			t.title_info(:ref=>[:title_info]) {
				t.title
			}
			t.name(path: "name") {
				t.name_part(path: "namePart")
				t.affiliation(path: "affiliation")
			}
			t.genre(path: "genre")
			t.hierarchical_geographic(path: "hierarchicalGeographic") {
				t.continent(path: "continent")
				t.country(path: "country")
				t.province(path: "province")
				t.region(path: "region")
				t.state(path: "state")
				t.territory(path: "territory")
				t.county(path: "county")
				t.city(path: "city")
				t.city_section(path: "citySection")
				t.island(path: "island")
				t.area(path: "area")
				t.extraterrestrial_area(path: "extraterrestrialArea")
			}
			t.cartographics(path: "cartographics") {
				t.coordinates(path: "coordinates")
				t.scale(path: "scale")
				t.projection(path: "projection")
			}
		}
		t.related_item(path: "relatedItem")
		t.identifier(path: "identifier")
		t.location(path: "location") {
			t.physical_location(path: "physicalLocation", index_as: :facetable) {
				t.id(:path=>{:attribute=>"id"})
			}
			t.url(path: "url")
			t.holding_simple(path: "holdingSimple") {
				t.copy_information(path: "copyInformation") {
					t.sub_location(path: "subLocation")
					t.shelf_locator(path: "shelfLocator")
					t.enumeration_and_chronology(path: "enumerationAndChronology")
				}
			}
		}
		t.access_condition(path: "accessCondition")
		t.record_info(path: "recordInfo") {
			t.record_content_source(path: "recordContentSource")
			t.record_origin(path: "recordOrigin")
			t.language_of_cataloging(path: "languageOfCataloging") {
				t.language_term(path: "languageTerm")
			}
			t.description_standard(path: "descriptionStandard")
		}
		t.image(path: "image") {
			t.original_image(path: "originalImage")
			t.full_image(path: "fullImage")
			t.thumb_image(path: "thumbImage")
		}
	end

	def self.xml_template
		Nokogiri::XML.parse("<mods/>")
	end
	
	def insert_title(main_title=nil, sub_title=nil, non_sort=nil)
		index = self.mods(0).title_info.count
		self.mods(0).title_info(index).title = main_title unless main_title.blank?
		self.mods(0).title_info(index).sub_title = sub_title unless sub_title.blank?
		self.mods(0).title_info(index).non_sort = non_sort unless non_sort.blank?
	end
	
	def update_title(main_title=nil, sub_title=nil, non_sort=nil, index)
		self.mods(0).title_info(index).title = main_title
		self.mods(0).title_info(index).sub_title = sub_title
		self.mods(0).title_info(index).non_sort = non_sort
	end
	
	def remove_title(index)
		self.mods(0).title_info(index,nil)
		#self.find_by_terms(:mods, :title_info).slice(index.to_i).remove
		#self.mods(0).title_info(index.to_i).remove
	end
	
	def clear_title()
		self.mods(0).title_info = nil
	end

	def insert_name(name_part=nil, affiliation=nil)
		index = self.mods(0).name.count
		self.mods(0).name(index).name_part = name_part unless name_part.blank?
		self.mods(0).name(index).affiliation = affiliation unless affiliation.blank?
	end
	
	def update_name(name_part=nil, affiliation=nil, index)
		self.mods(0).name(index).name_part = name_part
		self.mods(0).name(index).affiliation = affiliation
	end

	def insert_name_role(role_term=nil)
		#name_index = self.mods(0).name.count - 1
		name_index = 0
		index = self.mods(0).name(name_index).role.count
		self.mods(0).name(name_index).role(index).role_term = role_term unless role_term.blank?
	end
	
	def update_name_role(role_term=nil, name_index, index)
		self.mods(0).name(name_index).role(index).role_term = role_term
	end
	
	def remove_name(index)
		self.find_by_terms(:mods, :name).slice(index.to_i).remove
	end

	def insert_origin_info(publisher=nil, date_issued=nil, date_created=nil, copyright_date=nil, date_other=[], edition=nil)
		index = self.mods(0).origin_info.count
		self.mods(0).origin_info(index).publisher = publisher unless publisher.blank?
		self.mods(0).origin_info(index).date_issued = date_issued unless date_issued.blank?
		self.mods(0).origin_info(index).date_created = date_created unless date_created.blank?
		self.mods(0).origin_info(index).copyright_date = copyright_date unless copyright_date.blank?
		x = date_other.size
		while x > 0
			x -= 1
			if date_other[x].strip == ''
				date_other.delete_at(x)
			end
		end
		self.mods(0).origin_info(index).date_other = date_other unless date_other.blank?
		self.mods(0).origin_info(index).edition = edition unless edition.blank?
	end
	
	def update_origin_info(publisher=nil, date_issued=nil, date_created=nil, copyright_date=nil, date_other=[], edition=nil, index)
		self.mods(0).origin_info(index).publisher = publisher
		self.mods(0).origin_info(index).date_issued = date_issued
		self.mods(0).origin_info(index).date_created = date_created
		self.mods(0).origin_info(index).copyright_date = copyright_date
		x = date_other.size
		while x > 0
			x -= 1
			if date_other[x].strip == ''
				date_other.delete_at(x)
			end
		end
		self.mods(0).origin_info(index).date_other = date_other
		self.mods(0).origin_info(index).edition = edition
	end
	
	def remove_origin_info(index)
		self.find_by_terms(:mods, :origin_info).slice(index.to_i).remove
	end

	def insert_origin_info_place(place_term=nil)
		if self.mods(0).origin_info.count == 0
			index = 0
		else
			index = self.mods(0).origin_info.count - 1
		end
		#index = self.mods(0).origin_info.count - 1
		self.mods(0).origin_info(index).place.place_term = place_term unless place_term.blank?
	end
	
	def update_origin_info_place(place_term=nil, index)
		self.mods(0).origin_info(index).place.place_term = place_term
	end

	def insert_language(language_term=nil)
		index = self.mods(0).language.count
		self.mods(0).language(index).language_term = language_term unless language_term.blank?
	end
	
	def update_language(language_term=nil, index)
		self.mods(0).language(index).language_term = language_term
	end
	
	def remove_language(index)
		self.find_by_terms(:mods, :language).slice(index.to_i).remove
	end

	def insert_physical_description(internet_media_type=nil, extent=nil, digital_origin=nil, note=nil)
		self.mods(0).physical_description(0).internet_media_type = internet_media_type unless internet_media_type.blank?
		self.mods(0).physical_description(0).extent = extent unless extent.blank?
		self.mods(0).physical_description(0).digital_origin = digital_origin unless digital_origin.blank?
		self.mods(0).physical_description(0).note = note unless note.blank?
	end
	
	def update_physical_description(internet_media_type=nil, extent=nil, digital_origin=nil, note=nil)
		self.mods(0).physical_description(0).internet_media_type = internet_media_type
		self.mods(0).physical_description(0).extent = extent
		self.mods(0).physical_description(0).digital_origin = digital_origin
		self.mods(0).physical_description(0).note = note
	end
	
	def remove_physical_description(index)
		self.find_by_terms(:mods, :physical_description).slice(index.to_i).remove
	end

	def insert_note(note=nil, noteQualifier=nil)
		note_index = self.mods(0).note.count
		self.mods(0).note(note_index, note) unless note.blank?
		self.mods(0).note(note_index).type_at = noteQualifier unless noteQualifier.blank?
	end

	def remove_note(index)
		self.find_by_terms(:note).slice(index.to_i).remove
	end

	#def insert_subject(topic=[], geographic=nil, temporal=nil, title_info=nil)
	def insert_subject(topic=[], geographic=[], temporal=[])
		index = self.mods(0).subject.count
		x = topic.size
		while x > 0
			x -= 1
			if topic[x].strip == ''
				topic.delete_at(x)
			end
		end
		x = geographic.size
		while x > 0
			x -= 1
			if geographic[x].strip == ''
				geographic.delete_at(x)
			end
		end
		x = temporal.size
		while x > 0
			x -= 1
			if temporal[x].strip == ''
				temporal.delete_at(x)
			end
		end
		self.mods(0).subject(index).topic = topic unless topic.blank?
		self.mods(0).subject(index).geographic = geographic unless geographic.blank?
		self.mods(0).subject(index).temporal = temporal unless temporal.blank?
	end
	
	#def update_subject(topic=[], geographic=nil, temporal=nil, title_info=nil)
	def update_subject(topic=[], geographic=[], temporal=[])
		#index = self.mods(0).subject.count
		index = 0
		x = topic.size
		while x > 0
			x -= 1
			if topic[x].strip == ''
				topic.delete_at(x)
			end
		end
		x = geographic.size
		while x > 0
			x -= 1
			if geographic[x].strip == ''
				geographic.delete_at(x)
			end
		end
		x = temporal.size
		while x > 0
			x -= 1
			if temporal[x].strip == ''
				temporal.delete_at(x)
			end
		end
		self.mods(0).subject(index).topic = topic
		self.mods(0).subject(index).geographic = geographic
		self.mods(0).subject(index).temporal = temporal
	end

	def insert_subject_name(name_part=nil, affiliation=nil)
		#change subject to this if subject is repeating
		#if self.mods(0).subject.count == 0
		#	subject_index = 0
		#else
		#	subject_index = self.mods(0).subject.count - 1
		#end
		subject_index = 0
		index = self.mods(0).subject(subject_index).name.count
		self.mods(0).subject(subject_index).name(index).name_part = name_part unless name_part.blank?
		self.mods(0).subject(subject_index).name(index).affiliation = affiliation unless affiliation.blank?
	end
	
	def update_subject_name(name_part=nil, affiliation=nil, subject_index, index)
		self.mods(0).subject(subject_index).name(index).name_part = name_part
		self.mods(0).subject(subject_index).name(index).affiliation = affiliation
	end
	
	def remove_subject(index)
		self.find_by_terms(:subject).slice(index.to_i).remove
	end

	def insert_location(physical_location=nil, id=nil, url=nil, sub_location=nil, shelf_locator=nil, enumeration_and_chronology=nil)
		index = self.mods(0).location.count
		self.mods(0).location(index).physical_location = physical_location unless physical_location.blank?
		self.mods(0).location(index).physical_location.id = id unless id.blank?
		self.mods(0).location(index).url = url unless url.blank?
		self.mods(0).location(index).holding_simple(0).copy_information(0).sub_location = sub_location unless sub_location.blank?
		self.mods(0).location(index).holding_simple(0).copy_information(0).shelf_locator = shelf_locator unless shelf_locator.blank?
		self.mods(0).location(index).holding_simple(0).copy_information(0).enumeration_and_chronology = enumeration_and_chronology unless enumeration_and_chronology.blank?
	end

	def update_location(physical_location=nil, url=nil, sub_location=nil, shelf_locator=nil, enumeration_and_chronology=nil, index)
		self.mods(0).location(index).physical_location = physical_location
		self.mods(0).location(index).url = url
		self.mods(0).location(index).holding_simple(0).copy_information(0).sub_location = sub_location
		self.mods(0).location(index).holding_simple(0).copy_information(0).shelf_locator = shelf_locator
		self.mods(0).location(index).holding_simple(0).copy_information(0).enumeration_and_chronology = enumeration_and_chronology
	end
	
	def remove_location(index)
		self.find_by_terms(:mods, :location).slice(index.to_i).remove
	end

	def insert_record_info(record_content_source=nil, record_origin=nil, description_standard=nil)
		index = self.mods(0).record_info.count
		self.mods(0).record_info(index).record_content_source = record_content_source unless record_content_source.blank?
		self.mods(0).record_info(index).record_origin = record_origin unless record_origin.blank?
		self.mods(0).record_info(index).description_standard = description_standard unless description_standard.blank?
	end

	def update_record_info(record_content_source=nil, record_origin=nil, description_standard=nil, index)
		self.mods(0).record_info(index).record_content_source = record_content_source
		self.mods(0).record_info(index).record_origin = record_origin
		self.mods(0).record_info(index).description_standard = description_standard
	end

	def insert_record_info_language(language_term=nil)
		index = self.mods(0).record_info(0).language_of_cataloging.count
		self.mods(0).record_info(0).language_of_cataloging(index).language_term = language_term unless language_term.blank?
	end

	def update_record_info_language(language_term=nil, record_info_index, index)
		self.mods(0).record_info(record_info_index).language_of_cataloging(index).language_term = language_term
	end
	
	def remove_record_info(index)
		self.find_by_terms(:mods, :record_info).slice(index.to_i).remove
	end
	
	def insert_image(original_image=nil, full_image=nil, thumb_image=nil)
		index = self.mods(0).image.count
		self.mods(0).image(index).original_image = original_image
		self.mods(0).image(index).full_image = full_image
		self.mods(0).image(index).thumb_image = thumb_image
	end
	
	def update_image(original_image=nil, full_image=nil, thumb_image=nil, index)
		self.mods(0).image(index).original_image = original_image
		self.mods(0).image(index).full_image = full_image
		self.mods(0).image(index).thumb_image = thumb_image
	end
	
	def remove_image(index)
		self.find_by_terms(:mods, :image).slice(index.to_i).remove
	end

	#def prefix
		# set a datastream prefix if you need to namespace terms that might occur in multiple data streams 
	#	""
	#end

end
