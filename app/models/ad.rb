class Ad < ActiveRecord::Base
  validates_presence_of :name, :body
  enum status: [:enable, :disable]

  scope :for_list, -> { where(ad_type: 'LIST') }
  scope :for_sidebar, -> { where(ad_type: 'SIDEBAR') }

  before_save :expire_ad_cache
  before_destroy :expire_ad_cache

  before_create do
    self.version = SecureRandom.hex(8)
  end

  def expire_ad_cache
    case ad_type
    when "SIDEBAR"
      expire_fragment(/ads\/sidebar/)
    when "LIST"
      expire_fragment(/ads\/list/)
    end
  end

  private

  def expire_fragment cache_key
    ActionController::Base.new.expire_fragment cache_key
  end
end
