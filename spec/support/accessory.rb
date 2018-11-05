RSpec.configure do |config|
  config.before(:each) do
    RubyHome::Accessory.reset
  end
end
