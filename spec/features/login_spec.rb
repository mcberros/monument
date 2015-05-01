require 'rails_helper'

describe 'Users' do

  let!(:user) { create(:user) }


  it 'incorrect login goes to the login page' do
    visit root_path

    login_with(user.email, '456')

    expect(current_path).to eq(user_sessions_path)
  end


  it 'when login, it goes to the monument collection list and the mail of the user is shown' do
    visit root_path

    # It is necesary to hardcode the password with Factory Girl
    login_with(user.email, '123')

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Monument Collections')
    expect(page).to have_content(user.email)
  end

  it 'when we click the user email, we can update the password' do
    visit root_path

    # It is necesary to hardcode the password with Factory Girl
    login_with(user.email, '123')

    click_link "#{user.email}"

    fill_in 'Password', with: '345'
    fill_in 'Password confirmation', with: '345'

    click_button 'Update User'

    user.reload

    click_link 'Logout'

    login_with(user.email, '345')

    expect(page).to have_content('Monument Collections')
    expect(page).to have_content(user.email)
  end

  it 'when logout, it goes to the login page' do
    visit root_path

    # It is necesary to hardcode the password with Factory Girl
    login_with(user.email, '123')

    click_link 'Logout'

    expect(current_path).to eq(login_path)
  end

  it 'a new user is registered' do
  	visit root_path

    click_link 'Register'
    fill_in 'Password', with: '345'
    fill_in 'Password confirmation', with: '345'

    click_button 'Create User'

    expect(page).to have_content('Login')

  end
end