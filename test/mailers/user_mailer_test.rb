require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:cat)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    # assert_equal ["to@example.org"], mail.to
    assert_equal ["noreply@example.com"], mail.from
    # assert_equal ["from@example.com"], mail.from
    # make sure user name, token, and escaped email are in the email body
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

  test "password_reset" do
    user = users(:cat)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.reset_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

end
