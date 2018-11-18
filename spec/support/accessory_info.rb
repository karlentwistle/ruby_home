RSpec.configure do |config|
  config.before(:suite) do
    source = File.join(File.dirname(__FILE__), '/../tmp/accessory_info.yml')
    RubyHome::AccessoryInfo.source = source
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

  config.after(:suite) do
    if File.exists?(RubyHome::AccessoryInfo.source)
      File.delete(RubyHome::AccessoryInfo.source)
    end
  end
end
