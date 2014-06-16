class Ad < ActiveRecord::Base
  validates_presence_of :name, :body
  enum status: [:enable, :disable]

  scope :for_list, -> { where(ad_type: 'LIST', active: true).order('created_at ASC') }
  scope :for_sidebar, -> { where(ad_type: 'SIDEBAR', active: true).order('created_at ASC') }
  scope :for_detail, -> { where(ad_type: 'DETAIL', active: true).order('created_at ASC') }

  before_save :expire_ad_cache
  before_destroy :expire_ad_cache

  before_create do
    self.version = SecureRandom.hex(8)
  end

  AD_TYPES = %w(LIST SIDEBAR DETAIL)

  def expire_ad_cache
    expire_fragment(/ads\/#{ad_type.downcase}/)    
    # case ad_type
    # when "SIDEBAR"
    #   expire_fragment(/ads\/sidebar/)
    # when "LIST"
    #   expire_fragment(/ads\/list/)
    # when "DETAIL"
    #   expire_fragment(/ads\/detail/) 
    # end
  end

  private

  def expire_fragment cache_key
    ActionController::Base.new.expire_fragment cache_key
  end
end
