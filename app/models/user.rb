# encoding: utf-8
class User < ActiveRecord::Base
  has_secure_password
  
  acts_as_tagger
  mount_uploader :avatar, AvatarUploader

  validates :login, uniqueness: { case_sensitive: false }, allow_blank: true, format: { with: /\A[a-z0-9][a-z0-9-]*\z/i }
  validates :name, uniqueness: { case_sensitive: false }, presence: true, length: { maximum: 20, minimum: 2 }
  validates :email, uniqueness: { case_sensitive: false }, presence: true, format: { with: /\A([^@\s]+)@((?:[a-z0-9-]+\.)+[a-z]{2,})\z/i }

  has_many :jokes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def remember_token
    [id, Digest::SHA512.hexdigest(password_digest)].join('$')
  end

  def self.find_by_remember_token(token)
    user = find_by_id(token.split('$').first)
    (user && Rack::Utils.secure_compare(user.remember_token, token)) ? user : nil
  end

  def vote_for(joke, up_or_down)
    if (flag = up_or_down.to_i) > 0
      joke.increment!(:up_votes_count)
    else
      joke.increment!(:down_votes_count)
    end
    voted_joke_ids_will_change!
    voted_joke_ids.push joke.id
    save
  end

  def voted_for?(joke)
    voted_joke_ids.include? joke.id
  end

  def admin?
    Settings.admin_emails.include? email
  end
end
