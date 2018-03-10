ENV['RACK_ENV'] = 'test'

require 'bundler/setup'
require 'rack/test'
require 'rspec'
require_relative '../lib/rubyhome'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].sort.each { |file| require file }

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
