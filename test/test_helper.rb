ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...
  def is_logged_in?
  	session[:user_id]
  end

# can be used in controller test to log in as controller = access to session
  def logged_in_as(user)
  	session[:user_id] = user.id
  end
end


class ActionDispatch::IntegrationTest

	# log in as particular user in integration tests
	def log_in_as(user, password: 'password', remember_me: '1')
		post login_path, params: { session: { email: user.email, password: password, remember_me: remember_me } }
	end
	# ^ same  name is cool because they're used in distinct areas of code, but are effectively testing the same thing so helpful to just call "one method" wherever you are with the same argument (user)
end