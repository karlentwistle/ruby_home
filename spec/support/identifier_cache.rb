RSpec.configure do |config|
  config.before(:suite) do
    RubyHome::IdentifierCache.source = Tempfile.new('identifier_cache.yml')
  end

  config.after(:each) do
    RubyHome::IdentifierCache.truncate
  end
end
