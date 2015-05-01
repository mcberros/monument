require 'rails_helper'

describe 'Categories' do

  let!(:user_1) { create(:user) }
  let!(:user_2) { create(:user) }

  before(:each) do
  	visit root_path

	  login_with(user_1.email, '123')
  end

  context 'listing the categories' do
  	let!(:category_1) { create(:category, name: 'Cathedrals', user: user_1) }
  	let!(:category_2) { create(:category, name: 'Palaces', user: user_2) }

	  it 'shows the categories for the logged user' do
	    visit categories_path

	    expect(page).to have_content('Cathedrals')
	    expect(page).not_to have_content('Palaces')
	  end
	end

	context 'showing a category' do
  	let!(:category_1) { create(:category, name: 'Cathedrals', user: user_1) }
  	let!(:category_2) { create(:category, name: 'Palaces', user: user_2) }

	  it 'shows the categories for the logged user' do
	    visit categories_path

	    click_link 'Show'

	    expect(page).to have_content('Cathedrals')
	  end

	  it 'does not show a monument collection of other user' do
	    visit category_path(category_2)

	    expect(page).not_to have_content('Palaces')
      expect(page).to have_content('Forbidden')
	  end
	end

	context 'Create new category' do

		let!(:category_1) { create(:category, name: 'Cathedrals', user: user_1) }

		before(:each) do
			visit categories_path

	    expect(page).to have_content('Cathedrals')
	    expect(page).not_to have_content('Palace')

	    click_link 'New Category'

	    expect(page).to have_content('New Category')
		end

	  it 'after creating with all the necessary data, the list of categories is shown' do

	    fill_in 'Name', with: 'Palace'

	    click_button 'Create Category'

	    expect(page).to have_content('Category created')
	    expect(page).to have_content('Cathedrals')
	    expect(page).to have_content('Palace')
	  end

	  it 'after trying to create without all the necessary data, the form is shown' do

	    click_button 'Create Category'

	    expect(page).to have_content("Name can't be blank")
	    expect(page).to have_content('New Category')
	  end
	end

	context 'Update Category' do

		let!(:category_1) { create(:category, name: 'Cathedrals', user: user_1) }

		before(:each) do
			visit categories_path

	    expect(page).to have_content('Cathedrals')

	    click_link 'Edit'

	    expect(page).to have_content('Edit Category')
		end

	  it 'after updating with all the necessary data, the list of categories is shown' do

	    fill_in 'Name', with: 'Palace'

	    click_button 'Update Category'

	    expect(page).to have_content('Category updated')
	    expect(page).not_to have_content('Cathedrals')
	    expect(page).to have_content('Palace')
	  end

	  it 'after trying to update with empty data, the form is shown' do

	  	fill_in 'Name', with: ''
	    click_button 'Update Category'

	    expect(page).to have_content("Name can't be blank")
	    expect(page).to have_content('Edit Category')
	  end

	  context 'when a user try to edit the category of other user' do
	  	let!(:category_2) { create(:category, name: 'Palaces', user: user_2) }

	  	it 'receives a forbidden response' do
	  		visit edit_category_path(category_2)

	  		expect(page).not_to have_content('Palaces')
      	expect(page).to have_content('Forbidden')
	  	end
	  end
	end

	context 'Delete category', :js do

		let!(:category_1) { create(:category, name: 'Cathedrals', user: user_1) }

		before(:each) do
			visit categories_path

	    expect(page).to have_content('Cathedrals')

	    click_link 'Destroy'

	    accept_modal_window
		end

		it 'the Delete link deletes the category' do

    		expect(page).not_to have_content('Winter')
    		expect(page).to have_content('Category deleted')

		end
	end
end