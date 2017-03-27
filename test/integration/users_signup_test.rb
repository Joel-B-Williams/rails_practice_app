require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "does not save invalid users" do 
  	#get call not necessary, but does check that the path exists
  	get signup_path
  	assert_no_difference 'User.count' do
  		post users_path, params: { user: { name:  "",
                                     email: "user@invalid",
                                     password:              "foo",
                                     password_confirmation: "bar" } }
		end
		assert_template 'users/new'
		assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'form[action="/signup"]'
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
		follow_redirect!
		assert_template 'users/show'
		assert_select 'div.alert'
		#testing actual text is brittle = test for non-empty div
		assert_not flash.empty?
  end
end