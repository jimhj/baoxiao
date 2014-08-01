# encoding: utf-8
module JokeCacheSweeper
  extend ActiveSupport::Concern

  included do
    after_save :expire_joke_cache
    after_destroy :expire_joke_cache
  end

  def expire_joke_cache
    ActionController::Base.new.expire_fragment(%r{/*/index})
    ActionController::Base.new.expire_fragment(%r{/*/\?page*})
  end

  handle_asynchronously :expire_joke_cache, queue: 'expire_joke_cache'
end