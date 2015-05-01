class Category < ActiveRecord::Base
	belongs_to :user

	has_many :monuments

	validates :name, presence: true
end