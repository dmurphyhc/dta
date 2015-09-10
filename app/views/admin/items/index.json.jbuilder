json.array!(@items) do |item|
  json.extract! item, :id, :title_info, :name, :type_of_resource, :genre, :origin_info, :language, :physical_description, :abstract, :table_of_contents, :note, :subject, :related_item, :identifier, :location, :access_condition, :record_info
  json.url item_url(item, format: :json)
end
