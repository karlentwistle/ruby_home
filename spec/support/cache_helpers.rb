module CacheHelpers
  def set_cache(key, value)
    RubyHome::GlobalCache.instance[1][key.to_sym] = value
  end

  def read_cache(key)
    RubyHome::GlobalCache.instance[1] ||= RubyHome::Cache.new
    RubyHome::GlobalCache.instance[1][key.to_sym]
  end
end

RSpec.configure do |config|
  config.include CacheHelpers

  config.before(:each) do
    RubyHome::GlobalCache.instance[1] = RubyHome::Cache.new
  end

  config.after(:each) do |example|
    RubyHome::GlobalCache.instance[1] = nil
  end
end
