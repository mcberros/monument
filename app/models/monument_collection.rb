class MonumentCollection < ActiveRecord::Base
	belongs_to :user

	has_many :monuments, dependent: :destroy

	validates :name, presence: true

	def has_monuments?
		!self.monuments.empty?
	end
end