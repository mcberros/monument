class Monument < ActiveRecord::Base
	belongs_to :monument
	belongs_to :category
end