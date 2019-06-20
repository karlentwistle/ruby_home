require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
light_sensor = RubyHome::ServiceFactory.create(:light_sensor,
  current_ambient_light_level: 50000, # required
  name: "light sensor", # optional
  status_low_battery: 0, # optional
  status_tampered: 0, # optional
  status_fault: 0, # optional
  status_active: true # optional
)

light_sensor.current_ambient_light_level.after_update do |current_ambient_light_level|
  # maximum_value: 100000
  # minimum_value: 0.0001
  puts "light sensor current ambient light level #{current_ambient_light_level}"
end

light_sensor.status_low_battery.after_update do |status_low_battery|
  if status_low_battery == 0
    puts "light sensor low battery is battery level normal"
  elsif status_low_battery == 1
    puts "light sensor low battery is battery level low"
  end
end

light_sensor.status_tampered.after_update do |status_tampered|
  if status_tampered == 0
    puts "light sensor status_tampered not tampered"
  elsif status_tampered == 1
    puts "light sensor status_tampered tampered"
  end
end

light_sensor.status_fault.after_update do |status_fault|
  if status_fault == 0
    puts "light sensor status_fault no fault"
  elsif status_fault == 1
    puts "light sensor status_fault general fault"
  end
end

light_sensor.status_active.after_update do |active|
  if active
    puts "light sensor is active"
  else
    puts "light sensor is inactive"
  end
end

Thread.new do
  sleep 30

  loop do
    light_sensor.current_ambient_light_level = (1..100000).to_a.sample
    light_sensor.status_low_battery = (0..1).to_a.sample
    light_sensor.status_tampered = (0..1).to_a.sample
    light_sensor.status_fault = (0..1).to_a.sample
    light_sensor.status_active = [true, false].to_a.sample

    sleep 10
  end
end

RubyHome.run
