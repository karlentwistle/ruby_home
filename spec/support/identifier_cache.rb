RSpec.configure do |config|
  config.before(:each) do |example|
    RubyHome::IdentifierCache.source Tempfile.new.path
  end
end
