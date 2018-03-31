RSpec.configure do |config|
  config.before(:each) do |example|
    RubyHome::AccessoryInfo.pstore = PStore.new(Tempfile.new)
    RubyHome::AccessoryInfo.device_id = 'CB:45:B7:61:74:8C'
    RubyHome::AccessoryInfo.signature_key = 'E2889D17DD141C3A62969E85C7092FDB1080617FECCC08A60A5001AB6C79AB97'
  end
end

