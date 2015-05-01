require 'rails_helper'

describe 'Monument Collections' do

  let!(:user_1) { create(:user) }
  let!(:user_2) { create(:user) }

  before(:each) do
  	visit root_path

	  login_with(user_1.email, '123')
  end

  context 'listing the monument collections' do
  	let!(:monument_collection_1) { create(:monument_collection, name: 'Summer', user: user_1) }
  	let!(:monument_collection_2) { create(:monument_collection, name: 'Winter', user: user_2) }

	  it 'shows the monument collections for the logged user' do
	    visit monument_collections_path

	    expect(page).to have_content('Summer')
	    #expect(page).not_to have_content('Winter')
	  end
	end

	context 'showing a monument collection' do
  	let!(:monument_collection_1) { create(:monument_collection, name: 'Summer', user: user_1) }

	  it 'shows the monument collections for the logged user' do
	    visit monument_collections_path

	    click_link 'Show'

	    expect(page).to have_content('Summer')
	  end
	end

	context 'Create new monument collection' do

		let!(:monument_collection_1) { create(:monument_collection, name: 'Winter', user: user_1) }

		before(:each) do
			visit monument_collections_path

	    expect(page).to have_content('Winter')
	    expect(page).not_to have_content('Summer 2015')

	    click_link 'New Monument Collection'

	    expect(page).to have_content('New Collection')
		end

	  it 'after creating with all the necessary data, the list of monument collections is shown' do

	    fill_in 'Name', with: 'Summer 2015'

	    click_button 'Create Monument collection'

	    expect(page).to have_content('Collection created')
	    expect(page).to have_content('Winter')
	    expect(page).to have_content('Summer 2015')
	  end

	  it 'after trying to create without all the necessary data, the form is shown' do

	    click_button 'Create Monument collection'

	    expect(page).to have_content("Name can't be blank")
	    expect(page).to have_content('New Collection')
	  end
	end

	context 'Update monument collection' do

		let!(:monument_collection_1) { create(:monument_collection, name: 'Winter', user: user_1) }

		before(:each) do
			visit monument_collections_path

	    expect(page).to have_content('Winter')

	    click_link 'Edit'

	    expect(page).to have_content('Edit Collection')
		end

	  it 'after updating with all the necessary data, the list of monument collections is shown' do

	    fill_in 'Name', with: 'Summer 2015'

	    click_button 'Update Monument collection'

	    expect(page).to have_content('Collection updated')
	    expect(page).not_to have_content('Winter')
	    expect(page).to have_content('Summer 2015')
	  end

	  it 'after trying to update with empty data, the form is shown' do

	  	fill_in 'Name', with: ''
	    click_button 'Update Monument collection'

	    expect(page).to have_content("Name can't be blank")
	    expect(page).to have_content('Edit Collection')
	  end
	end

	context 'Delete monument collection', :js do

		let!(:monument_collection_1) { create(:monument_collection, name: 'Winter', user: user_1) }

		before(:each) do
			visit monument_collections_path

	    expect(page).to have_content('Winter')

	    click_link 'Destroy'

	    accept_modal_window
		end

		context 'the collection does not have monuments' do
		  it 'the Delete link deletes the monument collection' do

    		expect(page).not_to have_content('Winter')
    		expect(page).to have_content('Monument collection deleted')

		  end
		end

		context 'the collection has monuments' do
			let!(:monument) { create :monument, monument_collection: monument_collection_1 }

		  it 'the Delete link does not delete the monument collection' do

		    expect(page).to have_content('Winter')
    		expect(page).to have_content('Please delete the monuments before deleting the monument collection.')

		  end
		end
	end
end