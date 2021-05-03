require "ruby_home"

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
occupancy_sensor = RubyHome::ServiceFactory.create(:occupancy_sensor,
  motion_detected: false, # required
  name: "occupancy sensor", # optional
  status_low_battery: 0, # optional
  status_tampered: 0, # optional
  status_fault: 0, # optional
  status_active: true) # optional

occupancy_sensor.occupancy_detected.after_update do |occupancy_detected|
  if occupancy_detected == 0
    puts "occupancy sensor occupancy not detected"
  else
    puts "occupancy sensor occupancy detected"
  end
end

occupancy_sensor.status_low_battery.after_update do |status_low_battery|
  if status_low_battery == 0
    puts "occupancy sensor battery level normal"
  elsif status_low_battery == 1
    puts "occupancy sensor battery level lormal"
  end
end

occupancy_sensor.status_tampered.after_update do |status_tampered|
  if status_tampered == 0
    puts "occupancy sensor status_tampered not tampered"
  elsif status_tampered == 1
    puts "occupancy sensor status_tampered tampered"
  end
end

occupancy_sensor.status_fault.after_update do |status_fault|
  if status_fault == 0
    puts "occupancy sensor status_fault no fault"
  elsif status_fault == 1
    puts "occupancy sensor status_fault general fault"
  end
end

occupancy_sensor.status_active.after_update do |active|
  if active
    puts "occupancy sensor is active"
  else
    puts "occupancy sensor is inactive"
  end
end

Thread.new do
  sleep 30

  loop do
    occupancy_sensor.occupancy_detected = (0..1).to_a.sample
    occupancy_sensor.status_low_battery = (0..1).to_a.sample
    occupancy_sensor.status_tampered = (0..1).to_a.sample
    occupancy_sensor.status_fault = (0..1).to_a.sample
    occupancy_sensor.status_active = [true, false].to_a.sample

    sleep 10
  end
end

RubyHome.run
