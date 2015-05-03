class Picture < ActiveRecord::Base
	belongs_to :monument

	validates :name, presence: true

	mount_uploader :image, PictureUploader

	scope :not_approved, -> { joins(:monument)
						                .where('monuments.public = ?', true)
						                .where(approved: false)
						              }
end