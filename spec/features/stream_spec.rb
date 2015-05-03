require 'rails_helper'

describe 'Stream', :focus do
	let!(:user_1) { create(:user) }
  let!(:user_2) { create(:user) }

  let!(:monument_collection) { create :monument_collection, name: 'Sevilla', user: user_1 }
  let!(:category) { create :category, user: user_1, name: 'Cathedrals' }
  let!(:monument) { create :monument, name: 'Summer', category: category, monument_collection: monument_collection, public: true}
  let!(:picture) { create :picture, monument: monument, approved: true }

  it 'User 2 can see public pictures from User 1' do
  	visit root_path

    login_with(user_2.email, '123')

    expect(page).to have_content('Summer')
  end

  it 'Search by category', :js do
  	visit root_path

    login_with(user_2.email, '123')

    fill_in 'search_criteria', with: 'Hello'

    click_button 'Search'

    expect(page).not_to have_content('Summer')

    fill_in 'search_criteria', with: 'Sevilla'

    click_button 'Search'

    expect(page).to have_content('Summer')

    fill_in 'search_criteria', with: 'Cathedrals'

    click_button 'Search'

    expect(page).to have_content('Summer')
  end
end