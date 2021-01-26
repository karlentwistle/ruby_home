RSpec.configure do |config|
  config.around(:each) do |example|
    begin
      tempfile = Tempfile.new('identifier_cache.yml')
      RubyHome::IdentifierCache.source = tempfile
      example.run
    ensure
      tempfile.close
      tempfile.unlink
    end
  end
end
