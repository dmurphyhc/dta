class Item < ActiveFedora::Base
	contains 'descMetadata', class_name: 'ItemMetadata'

  has_attributes :title_info, datastream: 'descMetadata', multiple: true do |index|
    index.as :stored_searchable
  end
  has_attributes :name, datastream: 'descMetadata', multiple: true do |index|
    index.as :stored_searchable
  end

	has_attributes :genre, datastream: 'descMetadata', multiple: true do |index|
    index.as :stored_searchable
  end

	has_attributes :type_of_resource, datastream: 'descMetadata', multiple: true
  
	has_attributes :origin_info, datastream: 'descMetadata', multiple: true
	has_attributes :language, datastream: 'descMetadata', multiple: true
	has_attributes :physical_description, datastream: 'descMetadata', multiple: true
	#has_attributes :physical_description, datastream: 'descMetadata', multiple: false
	has_attributes :abstract, datastream: 'descMetadata', multiple: true
	has_attributes :table_of_contents, datastream: 'descMetadata', multiple: false
	has_attributes :note, datastream: 'descMetadata', multiple: true
	has_attributes :general_note, datastream: 'descMetadata', multiple: false
	has_attributes :preferred_citation, datastream: 'descMetadata', multiple: false
	has_attributes :biographical, datastream: 'descMetadata', multiple: false
	has_attributes :subject, datastream: 'descMetadata', multiple: true
	has_attributes :related_item, datastream: 'descMetadata', multiple: true
	has_attributes :identifier, datastream: 'descMetadata', multiple: true
	has_attributes :location, datastream: 'descMetadata', multiple: true
	has_attributes :access_condition, datastream: 'descMetadata', multiple: true
	has_attributes :record_info, datastream: 'descMetadata', multiple: true
	has_attributes :image, datastream: 'descMetadata', multiple: true
	#has_attributes :record_info, datastream: 'descMetadata', multiple: false

end
