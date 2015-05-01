module IntegrationHelpers
  def login_with(email, password)
	  fill_in 'Email', with: email
	  fill_in 'Password', with: password
	  click_button 'Login'
	end
end

RSpec.configure do |c|
  c.include IntegrationHelpers
end
