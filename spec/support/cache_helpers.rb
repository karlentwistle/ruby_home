module CacheHelpers
  def set_cache(key, value)
    RequestStore.store[1][key.to_sym] = value
  end

  def read_cache(key=nil)
    if key
      RequestStore.store[1][key.to_sym]
    else
      RequestStore.store[1]
    end
  end
end

RSpec.configure do |config|
  config.include CacheHelpers

  config.before(:each) do
    RequestStore.store[1] = {}
  end

  config.after(:each) do |example|
    RequestStore.clear!
  end
end
