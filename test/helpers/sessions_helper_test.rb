require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

	def setup
		# grab user from fixtures
		@user = users(:cat)
		# call remember method because it doesn't set session variable
		remember(@user)
	end

	test "current_user returns right user when session is nil" do 
		# current user will now be on the elsif 'remember' branch
		assert_equal @user, current_user
		assert is_logged_in?
	end

	test "current_user returns nil when remember digest is wrong" do 
		# set attribute to a new digested token so DB and current don't match
		@user.update_attribute(:remember_digest, User.digest(User.new_token))
		assert_nil current_user
	end
end