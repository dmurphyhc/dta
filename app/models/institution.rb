class Institution < ActiveRecord::Base

	self.primary_key = :id

	has_many :collections
	
end
