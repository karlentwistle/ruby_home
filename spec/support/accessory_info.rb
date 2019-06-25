RSpec.configure do |config|
  config.before(:suite) do
    RubyHome::AccessoryInfo.source = Tempfile.new('accessory_info.yml')
  end

  config.before(:each) do
    RubyHome::AccessoryInfo.reload
    RubyHome::AccessoryInfo.create(
      device_id: 'CB:45:B7:61:74:8C',
      paired_clients: [],
      password: '031-45-154',
      signature_key: 'E2889D17DD141C3A62969E85C7092FDB1080617FECCC08A60A5001AB6C79AB97',
    )
  end

  config.after(:each) do
    RubyHome::AccessoryInfo.truncate
  end
end
