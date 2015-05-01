require 'rails_helper'

describe 'Login' do

  let!(:user) { create(:user) }

  it 'goes to the monument collection list' do
    visit root_path

    # It is necesary to hardcode the password with Factory Girl
    login_with(user.email, '123')

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Monument Collections')
  end
end