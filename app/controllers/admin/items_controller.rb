require 'rmagick'

class Admin::ItemsController < ApplicationController
	before_action :set_item, only: [:show, :edit, :update, :destroy, :add_image, :save_image, :remove_image]
	before_action :set_institution, only: [:show, :edit, :update, :destroy, :new, :create, :add_image, :save_image, :remove_image]
	before_action :set_collection, only: [:show, :edit, :update, :destroy, :new, :create, :add_image, :save_image, :remove_image]

	respond_to :html

	def index
		@items = Item.all
		respond_with(@items)
	end
	
	def update_solr
		ActiveFedora::Base.all.each{ |e| e.update_index }
		redirect_to admin_items_path
	end

	def show
		respond_with(@item)
	end

	def new
		@item = Item.new
		respond_with(@item)
	end

	def edit
	end

	def create
		require 'digest/sha1'
		@item = Item.new()
		
		title_hash = Digest::SHA1.hexdigest item_params[:title_info][0].to_s
		id = Digest::SHA1.hexdigest title_hash.to_s + Time.now.to_s
		
		while Item.exists?(id)
			id = Digest::SHA1.hexdigest title_hash.to_s + Time.now.to_s
		end
		
		@item.id = id
		
		item_params[:title_info].each do |title_info|
			@item.descMetadata.insert_title(title_info[:title], title_info[:sub_title], title_info[:non_sort])
		end

		item_params[:name].each do |name|
			@item.descMetadata.insert_name(name[:name_part], name[:affiliation])
			name[:role].each do |role|
				@item.descMetadata.insert_name_role(role[:role_term])
			end
		end
		
		@item.type_of_resource = item_params[:type_of_resource].select { |a| a.present? }
		@item.genre = item_params[:genre].select { |a| a.present? }

		item_params[:origin_info].each do |origin_info|
			@item.descMetadata.insert_origin_info(origin_info[:publisher], origin_info[:date_issued], origin_info[:date_created], origin_info[:copyright_date], origin_info[:date_other], origin_info[:edition])
			@item.descMetadata.insert_origin_info_place(origin_info[:place][:place_term])
		end

		item_params[:language].each do |language|
			@item.descMetadata.insert_language(language[:language_term])
		end

		item_params[:physical_description].each do |physical_description|
			@item.descMetadata.insert_physical_description(physical_description[:internet_media_type], physical_description[:extent], physical_description[:digital_origin], physical_description[:note])
		end

		@item.abstract = params[:item][:abstract].select { |a| a.present? }

		@item.table_of_contents = item_params[:table_of_contents] unless item_params[:table_of_contents].blank?
		
		@item.general_note = item_params[:general_note] if item_params[:general_note].present?
		@item.preferred_citation = item_params[:citation] if item_params[:citation].present?
		@item.biographical = item_params[:biographical] if item_params[:biographical].present?
		
		#@item.note = item_params[:note] unless item_params[:note].blank?

		item_params[:subject].each do |subject|
			#@item.descMetadata.insert_subject(subject[:topic], subject[:geographic], subject[:temporal], subject[:title_info])
			@item.descMetadata.insert_subject(subject[:topic], subject[:geographic], subject[:temporal])
			
			subject[:name].each do |name|
				@item.descMetadata.insert_subject_name(name[:name_part], name[:affiliation])
			end
		end

		#@item.identifier = params[:item][:identifier].select { |a| a.present? }

		#item_params[:location].each do |location|
			#@item.descMetadata.insert_location(@institution.name, @institution.id, location[:url], location[:holding_simple][0][:copy_information][0][:sub_location], location[:holding_simple][0][:copy_information][0][:shelf_locator], location[:holding_simple][0][:copy_information][0][:enumeration_and_chronology])
			#@item.descMetadata.insert_location(@institution.name, @institution.id, item_params[:location][0][:url], item_params[:location][0][:holding_simple][0][:copy_information][0][:sub_location], item_params[:location][0][:holding_simple][0][:copy_information][0][:shelf_locator], item_params[:location][0][:holding_simple][0][:copy_information][0][:enumeration_and_chronology])
		#end

		@item.access_condition = params[:item][:access_condition].select { |a| a.present? }

		item_params[:record_info].each do |record_info|
			@item.descMetadata.insert_record_info(record_info[:record_content_source], record_info[:record_origin], record_info[:description_standard])
			record_info[:language_of_cataloging].each do |language_of_cataloging|
				@item.descMetadata.insert_record_info_language(language_of_cataloging[:language_term])
			end
		end
		
		@item.save
		#@item.descMetadata.to_solr
		respond_with([:admin, @item])
	end
=begin	
	def newTitle
		respond_with(@item)
	end
	
	def addTitle
		item_params[:title_info].each do |title_info|
			@item.descMetadata.insert_title(title_info[:title], title_info[:sub_title], title_info[:non_sort])
		end
		@item.save
		#@item.descMetadata.to_solr
		respond_with(@item)
	end
	
	def removeTitle
		@item.descMetadata.remove_title(params[:num].to_i)
		@item.save
		#@item.descMetadata.to_solr
		#respond_with(@item)
		redirect_to @item
	end
=end
	def update
		#@item.attributes = item_params

		#@item.descMetadata.clear_title()
		x = 0
		item_params[:title_info].each do |title_info|
			if title_info[:title].strip != "" or title_info[:sub_title].strip != "" or title_info[:non_sort].strip != ""
				@item.descMetadata.update_title(title_info[:title], title_info[:sub_title], title_info[:non_sort], x)
				x += 1
			end
		end
		if x < @item.title_info.size
			while x < @item.title_info.size
				@item.descMetadata.remove_title(x)
			end
		end
		
		item_params[:name].each do |name|
			if name[:name_part] != "" or name[:affiliation] != "" or name[:role][0][:role_term] != ""
				@item.descMetadata.update_name(name[:name_part], name[:affiliation], 0)
				name[:role].each do |role|
					@item.descMetadata.update_name_role(role[:role_term], 0, 0)
				end
			else
				if @item.descMetadata.find_by_terms(:mods, :name).size > 0
					@item.descMetadata.remove_name(0)
				end
			end
		end
		
		@item.type_of_resource = item_params[:type_of_resource].select { |a| a.present? }
		@item.genre = item_params[:genre].select { |a| a.present? }
		
		item_params[:origin_info].each do |origin_info|
			if origin_info[:publisher] != "" or origin_info[:date_issued] != "" or origin_info[:date_created] != "" or origin_info[:copyright_date] != "" or origin_info[:date_other][0] != "" or origin_info[:edition] != "" or origin_info[:place][:place_term] != ""
				@item.descMetadata.update_origin_info(origin_info[:publisher], origin_info[:date_issued], origin_info[:date_created], origin_info[:copyright_date], origin_info[:date_other], origin_info[:edition], 0)
				@item.descMetadata.update_origin_info_place(origin_info[:place][:place_term], 0)
			else
				if @item.descMetadata.find_by_terms(:mods, :origin_info).size > 0
					@item.descMetadata.remove_origin_info(0)
				end
			end
		end
		
		item_params[:language].each do |language|
			if language[:language_term] != ""
				@item.descMetadata.update_language(language[:language_term], 0)
			else
				if @item.descMetadata.find_by_terms(:mods, :language).size > 0
					@item.descMetadata.remove_language(0)
				end
			end
		end
		
		item_params[:physical_description].each do |physical_description|
			if physical_description[:internet_media_type].strip != "" or physical_description[:extent].strip != "" or physical_description[:digital_origin].strip != "" or physical_description[:note].strip != ""
				@item.descMetadata.update_physical_description(physical_description[:internet_media_type], physical_description[:extent], physical_description[:digital_origin], physical_description[:note])
			else
				if @item.descMetadata.find_by_terms(:mods, :physical_description).size > 0
					@item.descMetadata.remove_physical_description(0)
				end
			end
		end
		
		@item.abstract = params[:item][:abstract].select { |a| a.present? }

		if item_params[:table_of_contents] == ""
			@item.table_of_contents = nil
		else
			@item.table_of_contents = item_params[:table_of_contents]
		end
		
		if item_params[:general_note].present?
			@item.general_note = item_params[:general_note]
		else
			if @item.descMetadata.find_by_terms(:mods, :general_note).size > 0
				@item.general_note = nil
			end
		end
		
		if item_params[:citation].present?
			@item.preferred_citation = item_params[:citation]
		else
			if @item.descMetadata.find_by_terms(:mods, :preferred_citation).size > 0
				@item.preferred_citation = nil
			end
		end
		
		if item_params[:biographical].present?
			@item.biographical = item_params[:biographical]
		else
			if @item.descMetadata.find_by_terms(:mods, :biographical).size > 0
				@item.biographical = nil
			end
		end
		
		item_params[:subject].each do |subject|
			if subject[:topic][0] != "" or subject[:geographic][0] != "" or subject[:temporal][0] != "" or subject[:name][0][:name_part] != "" or subject[:name][0][:affiliation] != ""
				#@item.descMetadata.update_subject(subject[:topic], subject[:geographic], subject[:temporal], subject[:title_info])
				@item.descMetadata.update_subject(subject[:topic], subject[:geographic], subject[:temporal])
			
				x = 0
				subject[:name].each do |name|
					@item.descMetadata.update_subject_name(name[:name_part], name[:affiliation], 0, x)
					x += 1
				end
			else
				if @item.descMetadata.find_by_terms(:mods, :subject).size > 0
					@item.descMetadata.remove_subject(0)
				end
			end
		end

		item_params[:location].each do |location|
			if location[:physical_location] != "" or location[:url] != "" or location[:holding_simple][0][:copy_information][0][:sub_location] != "" or location[:holding_simple][0][:copy_information][0][:shelf_locator] != "" or location[:holding_simple][0][:copy_information][0][:enumeration_and_chronology] != ""
				@item.descMetadata.update_location(location[:physical_location], location[:url], location[:holding_simple][0][:copy_information][0][:sub_location], location[:holding_simple][0][:copy_information][0][:shelf_locator], location[:holding_simple][0][:copy_information][0][:enumeration_and_chronology], 0)
			else
				if @item.descMetadata.find_by_terms(:mods, :location).size > 0
					@item.descMetadata.remove_location(0)
				end
			end
		end

		@item.access_condition = params[:item][:access_condition].select { |a| a.present? }

		item_params[:record_info].each do |record_info|
			if record_info[:record_content_source] != "" or record_info[:record_origin] != "" or record_info[:description_standard] != "" or record_info[:language_of_cataloging][0][:language_term] != ""
				@item.descMetadata.update_record_info(record_info[:record_content_source], record_info[:record_origin], record_info[:description_standard], 0)
				record_info[:language_of_cataloging].each do |language_of_cataloging|
					@item.descMetadata.update_record_info_language(language_of_cataloging[:language_term], 0, 0)
				end
			else
				if @item.descMetadata.find_by_terms(:mods, :record_info).size > 0
					@item.descMetadata.remove_record_info(0)
				end
			end
		end
		
		@item.save
		respond_with([:admin, @item])
	end
	
	def save_image
		dir = "#{Rails.root}/public/uploads/#{@item.id}"
		time = Time.now.to_i
		params[:item][:image].each do |image|
			filename = File.basename(image.original_filename,File.extname(image.original_filename))
			original_filename = [filename, "_o_", time.to_s, File.extname(image.original_filename)].join
			full_filename = [filename, "_f_", time.to_s, ".jp2"].join
			thumb_filename = [filename, "_tn_", time.to_s, ".jpg"].join
		
			image_file = image.read
			Dir.mkdir(dir) unless File.exists?(dir)
			File.open(Rails.root.join('public', 'uploads', @item.id, original_filename), 'wb') do |file|
				file.write(image_file)
			end
		
			#img = Magick::Image.read(File.join(dir, original_filename)).first
			#path = File.join(dir, full_filename)
			#img.write(path)
			#thumb = img.resize_to_fit(300,300)
			#path = File.join(dir, thumb_filename)
			#thumb.write(path)
		
			@item.descMetadata.insert_image(original_filename, full_filename, thumb_filename)
		end
		
		@item.save
		
		redirect_to [:admin, @item]
	end
	
	def remove_image
		x = params[:num].to_i
		if File.file?("#{Rails.root}/public/uploads/#{@item.id}/" + @item.image(x).original_image[0])
			File.delete("#{Rails.root}/public/uploads/#{@item.id}/" + @item.image(x).original_image[0])
		end
		if File.file?("#{Rails.root}/public/uploads/#{@item.id}/" + @item.image(x).full_image[0])
			File.delete("#{Rails.root}/public/uploads/#{@item.id}/" + @item.image(x).full_image[0])
		end
		if File.file?("#{Rails.root}/public/uploads/#{@item.id}/" + @item.image(x).thumb_image[0])
			File.delete("#{Rails.root}/public/uploads/#{@item.id}/" + @item.image(x).thumb_image[0])
		end
		@item.descMetadata.update_image('', '', '', x)
		@item.descMetadata.remove_image(x)
		if @item.save
			redirect_to [:admin, @item]
		end
	end

	def destroy
		@item.destroy
		respond_with(@item)
	end

	private
		def set_item
			@item = Item.find(params[:id])
		end
		
		def set_collection
			if params[:collection_id] != nil
				@collection = Collection.find(params[:collection_id])
			end
		end
		
		def set_institution
			if params[:institution_id] != nil
				@institution = Institution.find(params[:institution_id])
			end
		end

		def item_params
			params.require(:item).permit(:table_of_contents,
																	 :general_note,
																	 :citation,
																	 :biographical,
																	 :title_info=>[:title, :sub_title, :part_number, :part_name, :non_sort],
																	 :name=>[:affiliation, :name_part=>[], :role=>[:role_term]],
																	 :type_of_resource=>[],
																	 :genre=>[],
																	 :origin_info=>[:publisher, :date_issued, :date_created, :copyright_date, :edition, :date_other=>[], :place=>[:place_term]],
																	 :language=>[:language_term],
																	 :physical_description=>[:internet_media_type, :extent, :digital_origin, :note],
																	 :abstract=>[],
																	 :subject=>[:title_info, :topic=>[], :geographic=>[], :temporal=>[], :name=>[:name_part, :affiliation]],
																	 :note=>[],
																	 :related_item=>[],
																	 :identifier=>[],
																	 :location=>[:physical_location, :url, :holding_simple=>[:copy_information=>[:sub_location, :shelf_locator, :enumeration_and_chronology]]],
																	 :access_condition=>[],
																	 :record_info=>[:record_content_source, :record_origin, :description_standard, :language_of_cataloging=>[:language_term]],
																	 :image=>[:original_image, :full_image, :thumb_image])
		end
end
