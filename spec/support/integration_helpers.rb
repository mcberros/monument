module IntegrationHelpers
  def login_with(email, password)
	  fill_in 'Email', with: email
	  fill_in 'Password', with: password
	  click_button 'Login'
	end

	def accept_modal_window
		alert = page.driver.browser.switch_to.alert
		alert.accept
	end
end

RSpec.configure do |c|
  c.include IntegrationHelpers
end
