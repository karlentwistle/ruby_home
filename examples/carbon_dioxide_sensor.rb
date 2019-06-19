require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
carbon_dioxide_sensor = RubyHome::ServiceFactory.create(:carbon_dioxide_sensor,
  carbon_dioxide_detected: 0, # required
  name: "carbon dioxide sensor", # optional
  carbon_dioxide_peak_level: 0, # optional
  carbon_dioxide_level: 0, # optional
  status_tampered: 0, # optional
  status_low_battery: 0, # optional
  status_fault: 0, # optional
  status_active: true # optional
)

carbon_dioxide_sensor.carbon_dioxide_detected.after_update do |carbon_dioxide_detected|
  if carbon_dioxide_detected == 0
    puts "carbon dioxide sensor carbon dioxide detected CO2 levels normal"
  elsif carbon_dioxide_detected == 1
    puts "carbon dioxide sensor carbon dioxide detected CO2 levels abnormal"
  end
end

carbon_dioxide_sensor.carbon_dioxide_peak_level.after_update do |carbon_dioxide_peak_level|
  puts "carbon dioxide sensor carbon_dioxide_peak_level #{carbon_dioxide_peak_level}"
end

carbon_dioxide_sensor.carbon_dioxide_level.after_update do |carbon_dioxide_level|
  puts "carbon dioxide sensor carbon_dioxide_level #{carbon_dioxide_level}"
end

carbon_dioxide_sensor.status_tampered.after_update do |status_tampered|
  if status_tampered == 0
    puts "carbon dioxide sensor status_tampered not tampered"
  elsif status_tampered == 1
    puts "carbon dioxide sensor status_tampered tampered"
  end
end

carbon_dioxide_sensor.status_low_battery.after_update do |status_low_battery|
  if status_low_battery == 0
    puts "battery service status low battery is battery level normal"
  elsif status_low_battery == 1
    puts "battery service status low battery is battery level low"
  end
end

carbon_dioxide_sensor.status_fault.after_update do |status_fault|
  if status_fault == 0
    puts "carbon dioxide sensor status_fault no fault"
  elsif status_fault == 1
    puts "carbon dioxide sensor status_fault general fault"
  end
end

carbon_dioxide_sensor.status_active.after_update do |active|
  if active
    puts "carbon dioxide sensor is active"
  else
    puts "carbon dioxide sensor is inactive"
  end
end

Thread.new do
  sleep 30

  loop do
    carbon_dioxide_sensor.carbon_dioxide_detected = (0..1).to_a.sample
    carbon_dioxide_sensor.carbon_dioxide_peak_level = (0..100000).to_a.sample
    carbon_dioxide_sensor.carbon_dioxide_level = (0..100000).to_a.sample
    carbon_dioxide_sensor.status_tampered = (0..1).to_a.sample
    carbon_dioxide_sensor.status_low_battery = (0..1).to_a.sample
    carbon_dioxide_sensor.status_fault = (0..1).to_a.sample
    carbon_dioxide_sensor.status_active = [true, false].to_a.sample

    sleep 10
  end
end

RubyHome.run
