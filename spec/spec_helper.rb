require 'bundler/setup'
require 'rack/test'
require 'rspec'
require_relative '../lib/rubyhome'

ENV['RACK_ENV'] = 'test'

require_relative '../lib/rubyhome/http/application'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].sort.each { |file| require file }

Rubyhome::AccessoryInfo.instance.tap do |accessory_info|
  accessory_info.device_id = 'CB:45:B7:61:74:8C'
  accessory_info.signing_key = Ed25519::SigningKey.new(
    ['E2889D17DD141C3A62969E85C7092FDB1080617FECCC08A60A5001AB6C79AB97'].pack('H*')
  )
end

module RSpecMixin
  include Rack::Test::Methods
  def app
    app = Rubyhome::HTTP::Application
    app.set :request_id, 1
    app
  end
end

RSpec.configure do |config|
  config.include RSpecMixin

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random
end
