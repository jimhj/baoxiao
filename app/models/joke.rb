class Joke < ActiveRecord::Base
  mount_uploader :picture, PictureUploader

  validates :title, uniqueness: true, length: { maximum: 40 }, allow_blank: true
  validates :content, presence: true, uniqueness: true, length: { minimum: 5, maximum: 200 }

  scope :recents, -> { where.not(title: nil).order('created_at DESC').limit(10) }
  scope :recent_pictures, -> { where.not(title: nil, picture: nil).order('created_at DESC').limit(10) }

  belongs_to :user

  def from
    case read_attribute(:from)
    when 'QB'; then '糗事百科';
    when 'MH'; then '快乐麻花';
    end
  end

end
