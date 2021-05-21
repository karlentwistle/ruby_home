RubyHome::IdentifierCache.source = "spec/tmp/identifier_cache.yml"

RSpec.configure do |config|
  config.before(:each) do |example|
    RubyHome::IdentifierCache.reset
  end
end
