# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation

  # calls method in user_mailer.rb file
  def account_activation
  	#define a user since method requires one now
    user = User.first
    # set its activation token as the DB doesn't have it - it's virtual
    user.activation_token = User.new_token
    # call method on our user
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    UserMailer.password_reset
  end

end
