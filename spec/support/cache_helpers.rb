module CacheHelpers
  def set_cache(key, value)
    request_store[key.to_sym] = value
  end

  def read_cache(key=nil)
    request_store[key]
  end

  def request_store
    RequestStore.store
  end

  def clear_cache
    RequestStore.clear!
  end
end

RSpec.configure do |config|
  config.include CacheHelpers

  config.after(:each) { clear_cache }
end
