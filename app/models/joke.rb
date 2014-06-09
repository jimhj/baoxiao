class Joke < ActiveRecord::Base
  mount_uploader :picture, PictureUploader

  validates :title, length: { maximum: 40 }
  validates :content, presence: true, uniqueness: true, length: { minimum: 10, maximum: 200 }

  belongs_to :user

end
