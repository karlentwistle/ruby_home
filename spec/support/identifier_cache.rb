RSpec.configure do |config|
  config.before(:each) do
    RubyHome::IdentifierCache.reload
    RubyHome::IdentifierCache.source = Tempfile.new.path
  end
end
