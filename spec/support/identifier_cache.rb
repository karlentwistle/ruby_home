RubyHome::IdentifierCache.source = Tempfile.new("identifier_cache.yml").path

puts Tempfile.new("identifier_cache.yml").path

RSpec.configure do |config|
  config.after(:each) do |example|
    RubyHome::IdentifierCache.reset
  end
end
