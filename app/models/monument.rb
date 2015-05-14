class Monument < ActiveRecord::Base
	include MonumentNavigation

	belongs_to :monument_collection
	belongs_to :category

	has_many :pictures, dependent: :destroy
	accepts_nested_attributes_for :pictures, :reject_if => lambda { |p| p[:name].blank? }, :allow_destroy => true

	validates :name, presence: true, :if => lambda { |monument| monument.current_step == "information" }

	scope :publish, -> { where public: true }

	scope :with_approved_pictures, -> { joins(:pictures).uniq.where('pictures.approved = ?', true) }

	scope :search_by, -> (criteria) { joins(:category, :monument_collection, :pictures)
                           					.uniq.publish
                           					.where('pictures.approved = ?', true)
                           					.where('categories.name = ? OR monument_collections.name = ?', criteria, criteria)}

  scope :by_user, -> (user_id) { joins(:monument_collection)
  															 .where('monument_collections.user_id = ?', user_id)
  															}

end