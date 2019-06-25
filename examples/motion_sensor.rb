require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
motion_sensor = RubyHome::ServiceFactory.create(:motion_sensor,
  motion_detected: false, # required
  name: "motion sensor", # optional
  status_low_battery: 0, # optional
  status_tampered: 0, # optional
  status_fault: 0, # optional
  status_active: true # optional
)

motion_sensor.motion_detected.after_update do |motion_detected|
  if motion_detected
    puts "motion sensor detected motion"
  else
    puts "motion sensor no motion detected"
  end
end

motion_sensor.status_low_battery.after_update do |status_low_battery|
  if status_low_battery == 0
    puts "motion sensor battery level normal"
  elsif status_low_battery == 1
    puts "motion sensor battery level lormal"
  end
end

motion_sensor.status_tampered.after_update do |status_tampered|
  if status_tampered == 0
    puts "motion sensor status_tampered not tampered"
  elsif status_tampered == 1
    puts "motion sensor status_tampered tampered"
  end
end

motion_sensor.status_fault.after_update do |status_fault|
  if status_fault == 0
    puts "motion sensor status_fault no fault"
  elsif status_fault == 1
    puts "motion sensor status_fault general fault"
  end
end

motion_sensor.status_active.after_update do |active|
  if active
    puts "motion sensor is active"
  else
    puts "motion sensor is inactive"
  end
end

Thread.new do
  sleep 30

  loop do
    motion_sensor.motion_detected = [true, false].to_a.sample
    motion_sensor.status_low_battery = (0..1).to_a.sample
    motion_sensor.status_tampered = (0..1).to_a.sample
    motion_sensor.status_fault = (0..1).to_a.sample
    motion_sensor.status_active = [true, false].to_a.sample

    sleep 10
  end
end

RubyHome.run
