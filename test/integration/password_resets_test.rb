require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
  	# clear count of delivered emails
  	ActionMailer::Base.deliveries.clear
  	@user = users(:cat)
  end

  test "password resets" do 
  	get new_password_reset_path
  	assert_template 'password_resets/new'
  	post password_resets_path, params: { password_reset: { email: "" } }
  	# should cause flash error
  	assert_not flash.empty?
  	# new template rendered
  	assert_template'password_resets/new'
  	post password_resets_path, params: { password_reset: { email: @user.email } }
# check for new reset_digest
  	assert_not_equal @user.reset_digest, @user.reload.reset_digest
  	# check 1 email now sent
  	assert_equal 1, ActionMailer::Base.deliveries.size
# should get confirmation message
  	assert_not flash.empty?
  	assert_redirected_to root_url
# password reset form, need that controllers user instance
  	user = assigns(:user)
  	get edit_password_reset_path(user.reset_token, email: "")
  	assert_redirected_to root_url
 # inactive user
  	user.toggle!(:activated)
  	get edit_password_reset_path(user.reset_token, email: user.email)
  	assert_redirected_to root_url
  	user.toggle!(:activated)
  	# wrong token
  	get edit_password_reset_path('wrong token', email: user.email)
  	assert_redirected_to root_url
  	# wrong email
  	get edit_password_reset_path(user.reset_token, email: 'email')
  	assert_redirected_to root_url
  	# correct info geez
  	get edit_password_reset_path(user.reset_token, email: user.email)
  	assert_template 'password_resets/edit'
  	assert_select "input[name=email][type=hidden][value=?]", user.email
  	# invalid password & confirmation
  	patch password_reset_path(user.reset_token),
		    params: { email: user.email,
		              user: { password:              "foobaz",
		              				password_confirmation: "barquux" } }
    # assert_select 'div#error_explanation'
    # empty password
		patch password_reset_path(user.reset_token),
		    params: { email: user.email,
		              user: { password:              "",
		                      password_confirmation: "" } }
		assert_select 'div#error_explanation'
		# valid finally gosh
		patch password_reset_path(user.reset_token),
				params: { email: user.email, 
									user: { password: "password",
									 				password_confirmation: "password" } }
		# user is logged in, conf message, redirected to profile
		assert is_logged_in?
		assert_not flash.empty?
		assert_redirected_to user

  end

end
