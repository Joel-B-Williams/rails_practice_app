require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = users(:cat)
    @other_user = users(:archer)
	end

  test "index including pagination" do 
  	log_in_as(@user)
  	get users_path
  	assert_template 'users/index'
  	assert_select 'div.pagination'
  	User.paginate(page: 1).each do |user|
  		assert_select 'a[href=?]', user_path(user), text: user.name
  	end
  end


  test "should redirect destroy when not logged in" do 
    assert_no_difference 'User.count' do 
      delete user_path(@user)
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy when logged in as non-admin" do 
    log_in_as(@other_user)
    assert_no_difference 'User.count' do 
      delete user_path(@user)
    end
    assert_redirected_to root_path
  end

  test "admins can activate orbital railguns" do 
    log_in_as(@user)
    assert_difference 'User.count', -1 do 
      delete user_path(@other_user)
    end
  end
end
