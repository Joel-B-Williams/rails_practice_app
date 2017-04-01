require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "does not save invalid users" do 
  	#get call not necessary, but does check that the path exists
  	get signup_path
  	assert_no_difference 'User.count' do
  		post users_path, params: { user: { name: "",
                                     email: "user@invalid",
                                     password:              "foo",
                                     password_confirmation: "bar" } }
		end
		assert_template 'users/new'
		assert_select 'div#error_explanation'
    # assert_select 'div.alert'
    # assert_select 'form[action="/signup"]'
    assert_select 'div.field_with_errors'
  end

  test "saves valid users" do 
  	get signup_path
  	#set the expected difference to 1
  	assert_difference 'User.count', 1 do
  		post users_path, params: { user: { name:  "pants",
                                     email: "user@valid.com",
                                     password:              "foobar",
                                     password_confirmation: "foobar" } }
		end
		# follow_redirect!
		# assert_template 'users/show'
  #   assert is_logged_in?
		# assert_select 'div.alert'
		# #testing actual text is brittle = test for non-empty div
		# assert_not flash.empty?

    # assert one email delivery has been sent
    assert_equal 1, ActionMailer::Base.deliveries.size
    # assign user to instance variable @user within controller
    user = assigns(:user)
    assert_not user.activated?
    log_in_as(user)
    assert_not is_logged_in?
    # check invalid token
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not is_logged_in?
    # check invalid email
    get edit_account_activation_path(user.activation_token, email: 'invalid@invalid')
    assert_not is_logged_in?
    # check valid token/email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    # assert_not flash.empty?
    # assert_redirected_to root_path
    # follow_redirect!
    # assert_template 'static_pages/home'
  end
end
