class User < ApplicationRecord
  #create an accessible token 
  attr_accessor :remember_token, :activation_token, :reset_token

  before_create :create_activation_digest
	before_save :downcase_email
	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
	has_secure_password
	validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  # allowing nill here is fine because nil passwords are still caught by has_secure_password.  This will actually stop the duplicate error message, in addition to allowing test cases to not need a password

  # blanket class methods inside this chunk
  class << self
    # Returns the hash digest of the given string.
    # for use in testing -> building fixture
    # class method because no access to instance in users.yml
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    # creates random 22-char string, will be using for access token key -> will be encrypted similarly to password digest
    def new_token
      SecureRandom.urlsafe_base64
    end

  end

# method to associate a 'remember token' with user and store it in DB
  def remember
    # virtual attribute becomes a random string
    self.remember_token = User.new_token
    # DB col becomes hashed version of that string (similar to password)
    # Note skipping validations with update_attr is good because we don't have the instance's password/confirmation to verify
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # method to forget a user so you can once more log out instead of being forced to stay for 20 years.  Womp.
  # set DB hash-string to nil
  def forget
    update_attribute(:remember_digest, nil)
  end

# Remember back to writing BCrypt password authentication -> this is doing the same with the hashed remember_token (cookie).  Reinflate the string held in DB, use re-written == to hash the virtual remember_token and compare the two.
# Same process, same reason - keeps cookie encrypted so even if it gets stolen the damage potential is minimalized.
# now re-written to be general use for any of the tokens/digests
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest) == token
  end

# activate account
  def activate
    update_attributes(activated: true, activated_at: Time.zone.now)
    # update_attribute(:activated_at, Time.zone.now)
  end

  # send activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    # update because they exist in DB
    update_attributes(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    # update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

    def create_activation_digest
      # called on a User.new object, these attributes are written into it and then saved into DB
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def downcase_email
      email.downcase!
    end

end
