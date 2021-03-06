class Comment < ActiveRecord::Base
  include PermanentRecords::ActiveRecord
  
  validates :body, presence: true, length: { maximum: 140 }

  belongs_to :user
  belongs_to :joke, touch: true, counter_cache: true

  def like_by_anonymous
    increment! :likes_count
  end
end
