class User < ActiveRecord::Base
  has_secure_password
  
  validates :login, uniqueness: { case_sensitive: false }, allow_blank: true, format: { with: /\A[a-z0-9][a-z0-9-]*\z/i }
  validates :name, uniqueness: { case_sensitive: false }, presence: true, length: { maximum: 20, minimum: 4 }
  validates :email, uniqueness: { case_sensitive: false }, presence: true, format: { with: /\A([^@\s]+)@((?:[a-z0-9-]+\.)+[a-z]{2,})\z/i }

  has_many :jokes
  
end
