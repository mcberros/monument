class Monument < ActiveRecord::Base

	belongs_to :monument_collection
	belongs_to :category

end