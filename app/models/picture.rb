class Picture < ActiveRecord::Base
	belongs_to :monument

	validates :name, presence: true
end