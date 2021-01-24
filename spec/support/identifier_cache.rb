RSpec.configure do |config|
  config.around(:each) do |example|
    begin
      tempfile = StringIO.new
      RubyHome::IdentifierCache.source = tempfile
      example.run
    ensure
      tempfile.close
    end
  end
end
