RSpec.configure do |config|
  config.before(:each) do |example|
    Rubyhome::IdentifierCache.reset!
  end
end

