class User < ApplicationRecord
    has_secure_password
  
    validates :username, presence: true, uniqueness: { case_sensitive: false }
    validates :email, presence: true,
              uniqueness: true,
              format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email" }
    validates :password, length: { minimum: 8 }, allow_nil: true
  end