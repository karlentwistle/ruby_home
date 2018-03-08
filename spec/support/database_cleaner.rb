require 'database_cleaner'

RSpec.configure do |config|
  config.around(:each) do |example|
    DatabaseCleaner[:active_record].strategy = :truncation

    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
