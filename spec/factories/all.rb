FactoryGirl.define do
	sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password "123"
    password_confirmation "123"
  end

  factory :monument_collection do
    name 'Summer'
    user
  end

  factory :monument do
    name 'Cathedral of Sevilla'
    description 'The third biggest cathedral in the world'
    public false
    approved false
    monument_collection
  end

  factory :category do
    name 'Cathedrals'
    user
  end
end