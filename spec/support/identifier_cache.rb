require 'database_cleaner'

RSpec.configure do |config|
  config.before(:each) do |example|
    Rubyhome::IdentifierCache.pstore = PStore.new(Tempfile.new)
  end
end

