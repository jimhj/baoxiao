class Ad < ActiveRecord::Base
  validates_presence_of :name, :body
  enum status: [:enable, :disable]

  AD_TYPES = %w(LIST SIDEBAR DETAIL RECOMMAND)

  class << self
    AD_TYPES.each do |ad_type|
      define_method "for_#{ad_type.downcase}" do
        where(ad_type: ad_type, active: true).order('created_at ASC')
      end
    end

    def recommad_jokes(list_number)
      Joke.where id: (for_recommand[list_number].try(:body) || "").split(/,|，/)
    end
  end

  before_create do
    self.version = SecureRandom.hex(8)
  end  

  before_save :expire_ad_cache
  before_destroy :expire_ad_cache

  def expire_ad_cache
    # expire_fragment use regexp as cache key just doesn't work.

    case ad_type
    when "LIST"
      expire_fragment 'ads_list_1'
      expire_fragment 'ads_list_2'      
    when "SIDEBAR"
      expire_fragment 'ads_sidebar_1'
      expire_fragment 'ads_sidebar_2'
      expire_fragment 'ads_sidebar_3'         
    when "DETAIL"
      expire_fragment 'ads_detail_1'
      expire_fragment 'ads_detail_2'
      expire_fragment 'ads_detail_3'
    when "RECOMMAND"
      expire_fragment 'ads_recommand_1'
      expire_fragment 'ads_recommand_2'
    end
  end

  private

  def expire_fragment cache_key, opts = nil
    ActionController::Base.new.expire_fragment cache_key
  end
end
