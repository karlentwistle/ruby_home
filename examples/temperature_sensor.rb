require "ruby_home"

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
temperature_sensor = RubyHome::ServiceFactory.create(:temperature_sensor,
  current_temperature: 30, # required
  name: "temperature sensor", # optional
  status_low_battery: 0, # optional
  status_tampered: 0, # optional
  status_fault: 0, # optional
  status_active: true) # optional

temperature_sensor.current_temperature.after_update do |current_temperature|
  puts "temperature sensor current_temperature #{current_temperature}"
end

temperature_sensor.status_low_battery.after_update do |status_low_battery|
  if status_low_battery == 0
    puts "temperature sensor battery level normal"
  elsif status_low_battery == 1
    puts "temperature sensor battery level lormal"
  end
end

temperature_sensor.status_tampered.after_update do |status_tampered|
  if status_tampered == 0
    puts "temperature sensor status_tampered not tampered"
  elsif status_tampered == 1
    puts "temperature sensor status_tampered tampered"
  end
end

temperature_sensor.status_fault.after_update do |status_fault|
  if status_fault == 0
    puts "temperature sensor status_fault no fault"
  elsif status_fault == 1
    puts "temperature sensor status_fault general fault"
  end
end

temperature_sensor.status_active.after_update do |active|
  if active
    puts "temperature sensor is active"
  else
    puts "temperature sensor is inactive"
  end
end

Thread.new do
  sleep 30

  loop do
    temperature_sensor.current_temperature = (0..100).to_a.sample
    temperature_sensor.status_low_battery = (0..1).to_a.sample
    temperature_sensor.status_tampered = (0..1).to_a.sample
    temperature_sensor.status_fault = (0..1).to_a.sample
    temperature_sensor.status_active = [true, false].to_a.sample

    sleep 10
  end
end

RubyHome.run
