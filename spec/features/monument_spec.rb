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
    let!(:category_1) { create(:category, name: 'Special', user: user_1) }
    let!(:monument_1) { create(:monument, name: 'Cathedral of Sevilla', monument_collection: monument_collection_1, category: category_1) }

    let!(:monument_collection_2) { create(:monument_collection, name: 'Granada', user: user_2) }
    let!(:monument_3) { create(:monument, name: 'Alhambra', monument_collection: monument_collection_2) }

    it 'shows the info for a monument' do
      visit monuments_path

      click_link "#{monument_1.name}"

      expect(page).to have_content('Cathedral of Sevilla')
      expect(page).to have_content('Summer - Sevilla')
      expect(page).to have_content('Special')
      expect(page).to have_content('The third biggest cathedral in the world')
      expect(page).to have_content('false')
    end

    it 'does not shows the info for the monument of other user' do
      visit monument_path(monument_3)

      expect(page).not_to have_content('Alhambra')
      expect(page).to have_content('Forbidden')
    end
  end

  context 'Create new monument', :js do

	  context 'there is no monument collection' do
	  	it 'it goes to the new monument_collection page' do
	  		visit monuments_path
	    	find('.glyphicon-plus').click

    	  expect(page).to have_content('Please, create first a monument collection')
	      expect(page).to have_content('New Collection')
	    end
	  end

	  context 'there is a monument_collection' do

	  	let!(:monument_collection) { create :monument_collection, user: user_1 }

      context 'there is no category' do
        it 'the monument is created' do
          visit monuments_path
          find('.glyphicon-plus').click

          fill_in 'Name', with: 'Alhambra'
          fill_in 'Description', with: 'Wonderful palace'
          check 'Public'

          click_button 'Next'

          click_button 'Next'

          expect(page).to have_content('Alhambra')

          click_button 'Save'

          expect(current_path).to eq(monuments_path)
          expect(page).to have_content('Alhambra')
        end
      end

      context 'there is a category' do
        let!(:category) { create :category, name: 'Palaces', user: user_1 }

        let!(:category_2) { create :category, name: 'Rivers', user: user_2 }

  	  	before(:each) do
  	  		visit monuments_path
  	    	find('.glyphicon-plus').click
  	  	end

  	    it 'after creating with all the necessary data, the list of monument collections is shown' do

          expect(page).not_to have_content('Rivers')

  	      fill_in 'Name', with: 'Alhambra'
  	      fill_in 'Description', with: 'Wonderful palace'
          expect(page).to have_content('Palaces')
  	      check 'Public'

  	      click_button 'Next'

          fill_in 'monument_pictures_attributes_0_name', with: 'Sun'
          attach_file('monument_pictures_attributes_0_image', "#{Rails.root}/spec/files/alhambra.jpg")

          click_button 'Next'

  	      expect(page).to have_content('Alhambra')
          expect(page).to have_content('Sun')

          click_button 'Save'

          expect(current_path).to eq(monuments_path)
          expect(page).to have_content('Alhambra')

  	    end

        it 'can create pictures without image' do

          expect(page).not_to have_content('Rivers')

          fill_in 'Name', with: 'Alhambra'
          fill_in 'Description', with: 'Wonderful palace'

          click_button 'Next'

          fill_in 'monument_pictures_attributes_0_name', with: 'Sun'

          click_button 'Next'

          expect(page).to have_content('Alhambra')
          expect(page).to have_content('Sun')

          click_button 'Save'

          expect(current_path).to eq(monuments_path)
          expect(page).to have_content('Alhambra')

        end

  	    it 'after trying to create without all the necessary data, the form is shown' do

      	  click_button 'Next'

  	      expect(page).to have_content("Name can't be blank")
  	      expect(page).to have_content('New Monument')
  	    end

        it 'goes to the summary, then picture step, and remove picture' do

          expect(page).not_to have_content('Rivers')

          fill_in 'Name', with: 'Alhambra'
          fill_in 'Description', with: 'Wonderful palace'
          expect(page).to have_content('Palaces')
          check 'Public'

          click_button 'Next'

          fill_in 'monument_pictures_attributes_0_name', with: 'Sun'
          attach_file('monument_pictures_attributes_0_image', "#{Rails.root}/spec/files/alhambra.jpg")

          click_button 'Next'

          expect(page).to have_content('Alhambra')
          expect(page).to have_content('Sun')

          click_button 'Back'

          find('.glyphicon-remove').click

          accept_modal_window

          click_button 'Next'

          expect(page).to have_content('Alhambra')
          expect(page).not_to have_content('Sun')

          click_button 'Save'

          expect(current_path).to eq(monuments_path)
          expect(page).to have_content('Alhambra')

        end

        it 'in picture step add extra picture,
        goes to the summary, then picture step, then summary step
        and the number of pictures is 2' do

          expect(page).not_to have_content('Rivers')

          fill_in 'Name', with: 'Alhambra'
          fill_in 'Description', with: 'Wonderful palace'
          expect(page).to have_content('Palaces')
          check 'Public'

          click_button 'Next'

          fill_in 'monument_pictures_attributes_0_name', with: 'Sun'
          attach_file('monument_pictures_attributes_0_image', "#{Rails.root}/spec/files/alhambra.jpg")

          find('.glyphicon-plus').click

          fill_in 'monument_pictures_attributes_1_name', with: 'Moon'
          attach_file('monument_pictures_attributes_1_image', "#{Rails.root}/spec/files/alhambra.jpg")

          click_button 'Next'

          expect(page).to have_content('Alhambra')
          expect(page).to have_content('Sun', count: 1)
          expect(page).to have_content('Moon', count: 1)

          click_button 'Back'

          click_button 'Next'

          expect(page).to have_content('Alhambra')
          expect(page).to have_content('Sun', count: 1)
          expect(page).to have_content('Moon', count: 1)

          click_button 'Save'

          expect(current_path).to eq(monuments_path)
          expect(page).to have_content('Alhambra')

        end
      end
	  end
  end

  context 'Update monument', :js do

    let!(:monument_collection_1) { create(:monument_collection, name: 'Winter', user: user_1) }
    let!(:category_1) { create :category, name: 'Palaces', user: user_1 }
    let!(:monument_1) { create(:monument, name: 'Cathedral of Sevilla', monument_collection: monument_collection_1, category: category_1) }


  	let!(:monument_collection_2) { create(:monument_collection, name: 'Granada', user: user_2) }
		let!(:monument_2) { create(:monument, name: 'Acueducto', monument_collection: monument_collection_2) }

    before(:each) do
      visit monuments_path

      expect(page).to have_content('Cathedral of Sevilla')

      find('.glyphicon-pencil').click

      expect(page).to have_content('Edit Monument')
    end

    it 'after updating with all the necessary data, the list of monuments is shown' do

      fill_in 'Name', with: 'Alhambra'

      click_button 'Next'

      click_button 'Next'

      expect(page).not_to have_content('Cathedral')
      expect(page).to have_content('Alhambra')

      click_button 'Save'

      expect(current_path).to eq(monuments_path)
      expect(page).to have_content('Alhambra')
    end

    it 'after trying to update with empty data, the form is shown' do

      fill_in 'Name', with: ''
      click_button 'Next'

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

      find('.glyphicon-remove').click

      accept_modal_window

      expect(page).not_to have_content('Cathedral of Sevilla')
      expect(page).to have_content('Monument deleted')
    end
  end
end