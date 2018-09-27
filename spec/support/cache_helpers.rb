module CacheHelpers
  def set_cache(key, value)
    request_store[key.to_sym] = value
  end

  def read_cache(key=nil)
    request_store[key]
  end

  def request_store
    RubyHome.socket_store[stub_socket] ||= {}
  end

  def clear_cache
    RubyHome.socket_store[stub_socket] = {}
  end

  def stub_socket
    1
  end
end

RSpec.configure do |config|
  config.include CacheHelpers

  config.before(:each) do
    request_store
    env "REQUEST_SOCKET", stub_socket
  end

  config.after(:each) do
    clear_cache
  end
end
