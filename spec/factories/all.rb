FactoryGirl.define do
  factory :user do
    email "user@example.com"
    password "123"
    password_confirmation "123"
  end
end