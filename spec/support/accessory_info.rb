EXAMPLE_DEVICE_ID = -'CB:45:B7:61:74:8C'
EXAMPLE_PAIRED_CLIENTS = []
EXAMPLE_PASSWORD = -'031-45-154'
EXAMPLE_SIGNATURE_KEY = -'E2889D17DD141C3A62969E85C7092FDB1080617FECCC08A60A5001AB6C79AB97'

RSpec.configure do |config|
  config.around(:each) do |example|
    begin
      tempfile = Tempfile.new('accessory_info.yml')
      RubyHome::AccessoryInfo.source = tempfile
      RubyHome::AccessoryInfo.reload
      RubyHome::AccessoryInfo.create(
        device_id: EXAMPLE_DEVICE_ID,
        paired_clients: EXAMPLE_PAIRED_CLIENTS,
        password: EXAMPLE_PASSWORD,
        signature_key: EXAMPLE_SIGNATURE_KEY,
      )
      example.run
    ensure
      tempfile.close
      tempfile.unlink
    end
  end
end
