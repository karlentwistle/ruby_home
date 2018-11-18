RSpec.configure do |config|
  config.before(:suite) do
    source = File.join(File.dirname(__FILE__), '/../tmp/identifier_cache.yml')
    RubyHome::IdentifierCache.source = source
  end

  config.after(:each) do
    RubyHome::IdentifierCache.truncate
  end

  config.after(:suite) do
    if File.exists?(RubyHome::IdentifierCache.source)
      File.delete(RubyHome::IdentifierCache.source)
    end
  end
end
