class User < ApplicationRecord
  #create an accessible token 
  attr_accessor :remember_token

	before_save { email.downcase! }
	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
	has_secure_password
	validates :password, presence: true, length: {minimum: 6}

  # blanket class methods inside this chunk
  class << self
    # Returns the hash digest of the given string.
    # for use in testing -> building fixture
    # class method because no access to instance in users.yml
    def self.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    # creates random 22-char string, will be using for access token key -> will be encrypted similarly to password digest
    def self.new_token
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
end
