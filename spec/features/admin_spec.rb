require 'rails_helper'

describe 'Admin' do

  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }

  let!(:monument_collection) { create :monument_collection, user: user }
  let!(:monument) { create :monument, monument_collection: monument_collection, public: true}
  let!(:picture) { create :picture, monument: monument }

  it 'Admin can see the pictures page and approve pictures' do
  	visit root_path

    login_with(admin.email, '123')

    visit pictures_path

    expect(page).to have_content('Sun')

    click_button 'Approve'

    expect(page).not_to have_content('Sun')
  end
end
