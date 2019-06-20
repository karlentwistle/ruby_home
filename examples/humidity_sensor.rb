require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
humidity_sensor = RubyHome::ServiceFactory.create(:humidity_sensor,
  current_relative_humidity: 20, # required
  name: "humidity sensor", # optional
  status_low_battery: 0, # optional
  status_tampered: 0, # optional
  status_fault: 0, # optional
  status_active: true # optional
)

humidity_sensor.current_relative_humidity.after_update do |current_relative_humidity|
  puts "humidity sensor current relative humidity #{current_relative_humidity}"
end

humidity_sensor.status_low_battery.after_update do |status_low_battery|
  if status_low_battery == 0
    puts "humidity sensor low battery is battery level normal"
  elsif status_low_battery == 1
    puts "humidity sensor low battery is battery level low"
  end
end

humidity_sensor.status_tampered.after_update do |status_tampered|
  if status_tampered == 0
    puts "humidity sensor status_tampered not tampered"
  elsif status_tampered == 1
    puts "humidity sensor status_tampered tampered"
  end
end

humidity_sensor.status_fault.after_update do |status_fault|
  if status_fault == 0
    puts "humidity sensor status_fault no fault"
  elsif status_fault == 1
    puts "humidity sensor status_fault general fault"
  end
end

humidity_sensor.status_active.after_update do |active|
  if active
    puts "humidity sensor is active"
  else
    puts "humidity sensor is inactive"
  end
end

Thread.new do
  sleep 30

  loop do
    humidity_sensor.current_relative_humidity = (0..100).to_a.sample
    humidity_sensor.status_low_battery = (0..1).to_a.sample
    humidity_sensor.status_tampered = (0..1).to_a.sample
    humidity_sensor.status_fault = (0..1).to_a.sample
    humidity_sensor.status_active = [true, false].to_a.sample

    sleep 10
  end
end

RubyHome.run
