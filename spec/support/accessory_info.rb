EXAMPLE_DEVICE_ID = -"CB:45:B7:61:74:8C"
EXAMPLE_PAIRED_CLIENTS = []
EXAMPLE_PASSWORD = -"031-45-154"
EXAMPLE_SIGNATURE_KEY = -"E2889D17DD141C3A62969E85C7092FDB1080617FECCC08A60A5001AB6C79AB97"
RubyHome::AccessoryInfo.source = Tempfile.new("accessory_info.yml").path

RSpec.configure do |config|
  config.before(:each) do
    RubyHome::AccessoryInfo.create(
      device_id: EXAMPLE_DEVICE_ID,
      paired_clients: EXAMPLE_PAIRED_CLIENTS,
      password: EXAMPLE_PASSWORD,
      signature_key: EXAMPLE_SIGNATURE_KEY
    )
  end

  config.after(:each) do |example|
    RubyHome::AccessoryInfo.reset
    RubyHome::AccessoryInfo.reload
  end
end
