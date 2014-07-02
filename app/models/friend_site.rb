class FriendSite < ActiveRecord::Base
  validates_presence_of :name, :url, :priority

  enum status: [ :pending, :approved, :rejected ]

  scope :approved, -> {
    where(status: FriendSite.statuses[:approved]).order('priority DESC, id DESC')
  }
end
