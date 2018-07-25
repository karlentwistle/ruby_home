module CacheHelpers
  def set_cache(key, value)
    stub_request_store[key.to_sym] = value
  end

  def read_cache(key=nil)
    stub_request_store.fetch(key, stub_request_store)
  end

  def stub_request_store
    RequestStore.store[stub_request_key] ||= {}
  end

  def stub_request_key
    1
  end
end

RSpec.configure do |config|
  config.include CacheHelpers

  config.before(:each) do
    env "REQUEST_SOCKET", stub_request_key
  end

  config.after(:each) do |example|
    RequestStore.clear!
  end
end
