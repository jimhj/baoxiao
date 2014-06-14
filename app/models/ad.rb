class Ad < ActiveRecord::Base
  validates_presence_of :name, :body
  enum status: [:enable, :disable]

  before_create do
    self.version = SecureRandom.hex(8)
  end
end
