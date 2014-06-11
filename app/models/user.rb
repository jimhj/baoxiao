class User < ActiveRecord::Base
  has_secure_password
  
  validates :login, uniqueness: { case_sensitive: false }, allow_blank: true, format: { with: /\A[a-z0-9][a-z0-9-]*\z/i }
  validates :name, uniqueness: { case_sensitive: false }, presence: true, length: { maximum: 20, minimum: 4 }
  validates :email, uniqueness: { case_sensitive: false }, presence: true, format: { with: /\A([^@\s]+)@((?:[a-z0-9-]+\.)+[a-z]{2,})\z/i }

  has_many :jokes, dependent: :destroy

  def remember_token
    [id, Digest::SHA512.hexdigest(password_digest)].join('$')
  end

  def self.find_by_remember_token(token)
    user = find_by_id(token.split('$').first)
    (user && Rack::Utils.secure_compare(user.remember_token, token)) ? user : nil
  end  
end
