require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path
    assert_response :success
  end

  # test "should post create" do
  #   post login_path
  #   assert_response :success
  # end

  # test "should delete" do
  #   delete logout_path
  #   assert_redirected_to root_path
  # end

end
