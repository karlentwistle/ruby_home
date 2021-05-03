require "ruby_home"

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
smoke_sensor = RubyHome::ServiceFactory.create(:smoke_sensor,
  smoke_detected: 0, # required
  name: "smoke sensor", # optional
  status_low_battery: 0, # optional
  status_tampered: 0, # optional
  status_fault: 0, # optional
  status_active: true) # optional

smoke_sensor.smoke_detected.after_update do |smoke_detected|
  if smoke_detected == 0
    puts "smoke sensor smoke not detected"
  elsif smoke_detected == 1
    puts "smoke sensor smoke detected"
  end
end

smoke_sensor.status_low_battery.after_update do |status_low_battery|
  if status_low_battery == 0
    puts "smoke sensor battery level normal"
  elsif status_low_battery == 1
    puts "smoke sensor battery level lormal"
  end
end

smoke_sensor.status_tampered.after_update do |status_tampered|
  if status_tampered == 0
    puts "smoke sensor status_tampered not tampered"
  elsif status_tampered == 1
    puts "smoke sensor status_tampered tampered"
  end
end

smoke_sensor.status_fault.after_update do |status_fault|
  if status_fault == 0
    puts "smoke sensor status_fault no fault"
  elsif status_fault == 1
    puts "smoke sensor status_fault general fault"
  end
end

smoke_sensor.status_active.after_update do |active|
  if active
    puts "smoke sensor is active"
  else
    puts "smoke sensor is inactive"
  end
end

Thread.new do
  sleep 30

  loop do
    smoke_sensor.smoke_detected = (0..1).to_a.sample
    smoke_sensor.status_low_battery = (0..1).to_a.sample
    smoke_sensor.status_tampered = (0..1).to_a.sample
    smoke_sensor.status_fault = (0..1).to_a.sample
    smoke_sensor.status_active = [true, false].to_a.sample

    sleep 10
  end
end

RubyHome.run
