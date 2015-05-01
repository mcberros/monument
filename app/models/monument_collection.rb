class MonumentCollection < ActiveRecord::Base
	belongs_to :user

	has_many :monuments, dependent: :destroy
end