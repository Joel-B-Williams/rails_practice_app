require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    #users = users.yml, :cat = key to cat hash
    @user = users(:cat)
  end
  
  test "gets login path" do 
  	get login_path
  	assert_template 'sessions/new'
  	post login_path, params: {session: {email: "", password: ""}}
  	assert_template 'sessions/new'
  	assert_not flash.empty?
  	get root_path
  	assert flash.empty?
  end

  test "Valid log in and log out" do 
    get login_path
    #password hardcoded here because there's no password column in DB so rails would freak if it was in yml file
    post login_path, params: { session: { email: @user.email, password: 'password' }}
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path 
    assert_select "a[href=?]", user_path(@user) 
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # simulate user logging out from 2nd window
    delete logout_path
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", users_path(@user), count: 0
  end

  test "login with remembering" do 
    # use helper method to log in 
    log_in_as(@user)
    # check cookie to make sure it's not empty - aka the remember token is stored there
    # note this is one of those weird hashes that doesn't take symbols
    assert_not_empty cookies['remember_token']
    # now that session#create has instance variable we can look at it's virtual attributes with assigns and make sure they directly match the cookie
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do 
    # tried this first but cookie is not set unless you are remembered first so got nil class error.  Womp.
    # log_in_as(@user, remember_me: '0')
    # assert_empty cookies['remember_token']
    log_in_as(@user)
    assert_not_empty cookies['remember_token']
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end

  test "redirects login if not activated" do 
    @user.toggle!(:activated)
    log_in_as(@user)
    assert_redirected_to root_path
    assert_not flash.empty?
  end

end
