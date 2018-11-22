module SessionHelpers
  def session
    @session ||= RubyHome::HAP::Session.new(StringIO.new)
  end

  def reset_session
    @session = nil
  end
end

RSpec.configure do |config|
  config.include SessionHelpers

  config.before(:each) do
    env "REQUEST_SESSION", session
  end

  config.after(:each) do
    reset_session
  end
end
