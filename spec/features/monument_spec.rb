require 'rails_helper'

describe 'Monuments' do

  let!(:user_1) { create(:user) }
  let!(:user_2) { create(:user) }

  before(:each) do
      visit root_path

      login_with(user_1.email, '123')
  end

  context 'index' do
  		let!(:monument_collection_1) { create(:monument_collection, name: 'Summer - Sevilla', user: user_1) }
  		let!(:monument_collection_2) { create(:monument_collection, name: 'Granada', user: user_2) }

      let!(:monument_1) { create(:monument, name: 'Cathedral of Sevilla', monument_collection: monument_collection_1) }
      let!(:monument_2) { create(:monument, name: 'Giralda', monument_collection: monument_collection_1) }
      let!(:monument_3) { create(:monument, name: 'Alhambra', monument_collection: monument_collection_2) }

      it 'shows the list of monuments for the user' do
        visit monuments_path

        expect(page).to have_content('Cathedral of Sevilla')
        expect(page).to have_content('Giralda')
        expect(page).not_to have_content('Alhambra')
      end
    end

  context 'showing a monument' do
  	let!(:monument_collection_1) { create(:monument_collection, name: 'Summer - Sevilla', user: user_1) }
	  let!(:monument_collection_2) { create(:monument_collection, name: 'Granada', user: user_2) }

    let!(:monument_1) { create(:monument, name: 'Cathedral of Sevilla', monument_collection: monument_collection_1) }
    let!(:monument_3) { create(:monument, name: 'Alhambra', monument_collection: monument_collection_2) }

    it 'shows the info for a monument' do
      visit monuments_path

      click_link 'Show'

      expect(page).to have_content('Cathedral of Sevilla')
      expect(page).to have_content('Summer - Sevilla')
      expect(page).to have_content('The third biggest cathedral in the world')
      expect(page).to have_content('false')
    end

    it 'does not shows the info for the monument of other user' do
      visit monument_path(monument_3)

      expect(page).not_to have_content('Alhambra')
      expect(page).to have_content('Forbidden')
    end
  end

  context 'Create new monument' do

	  context 'there is no monument collection' do
	  	it 'it goes to the new monument_collection page' do
	  		visit monuments_path
	    	click_link 'New Monument'

    	  expect(page).to have_content('Please, create first a monument collection')
	      expect(page).to have_content('New Collection')
	    end
	  end

	  context 'there is a monument_collection' do

	  	let!(:monument_collection) { create :monument_collection, user: user_1 }

	  	before(:each) do
	  		visit monuments_path
	    	click_link 'New Monument'
	  	end

	    it 'after creating with all the necessary data, the list of monument collections is shown' do

	      fill_in 'Name', with: 'Alhambra'
	      fill_in 'Description', with: 'Wonderful palace'
	      check 'Public'

	      click_button 'Create Monument'

	      expect(page).to have_content('Alhambra')
	    end

	    it 'after trying to create without all the necessary data, the form is shown' do

    	  click_button 'Create Monument'

	      expect(page).to have_content("Name can't be blank")
	      expect(page).to have_content('New Monument')
	    end
	  end
  end

  context 'Update monument' do

    let!(:monument_collection_1) { create(:monument_collection, name: 'Winter', user: user_1) }
    let!(:monument_1) { create(:monument, name: 'Cathedral of Sevilla', monument_collection: monument_collection_1) }

  	let!(:monument_collection_2) { create(:monument_collection, name: 'Granada', user: user_2) }
		let!(:monument_2) { create(:monument, name: 'Acueducto', monument_collection: monument_collection_2) }

    before(:each) do
      visit monuments_path

      expect(page).to have_content('Cathedral of Sevilla')

      click_link 'Edit'

      expect(page).to have_content('Edit Monument')
    end

    it 'after updating with all the necessary data, the list of monuments is shown' do

      fill_in 'Name', with: 'Alhambra'

      click_button 'Update Monument'

      expect(page).to have_content('Monument updated')
      expect(page).not_to have_content('Cathedral')
      expect(page).to have_content('Alhambra')
    end

    it 'after trying to update with empty data, the form is shown' do

      fill_in 'Name', with: ''
      click_button 'Update Monument'

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content('Edit Monument')
    end

    it 'does not shows the info for the monument of other user' do
      visit monument_path(monument_2)

      expect(page).not_to have_content('Acueducto')
      expect(page).to have_content('Forbidden')
    end
  end

  context 'Delete monument', :js do

  	let!(:monument_collection_1) { create(:monument_collection, name: 'Summer - Sevilla', user: user_1) }
    let!(:monument_1) { create(:monument, name: 'Cathedral of Sevilla', monument_collection: monument_collection_1) }

    it 'the Delete link deletes the monument' do

      visit monuments_path

      click_link 'Destroy'

      accept_modal_window

      expect(page).not_to have_content('Cathedral of Sevilla')
      expect(page).to have_content('Monument deleted')
    end
  end
end