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
    monument_collection
  end
end