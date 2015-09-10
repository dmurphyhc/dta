class Collection < ActiveRecord::Base

	self.primary_key = :id

  belongs_to :institution

end
