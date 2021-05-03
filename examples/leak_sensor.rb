require "ruby_home"

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
leak_sensor = RubyHome::ServiceFactory.create(:leak_sensor,
  leak_detected: 0, # required
  name: "leak sensor", # optional
  status_low_battery: 0, # optional
  status_tampered: 0, # optional
  status_fault: 0, # optional
  status_active: true) # optional

leak_sensor.leak_detected.after_update do |leak_detected|
  if leak_detected == 0
    puts "leak sensor leak detected leak not detected"
  elsif leak_detected == 1
    puts "leak sensor leak detected leak detected"
  end
end

leak_sensor.status_low_battery.after_update do |status_low_battery|
  if status_low_battery == 0
    puts "leak sensor low battery is battery level normal"
  elsif status_low_battery == 1
    puts "leak sensor low battery is battery level low"
  end
end

leak_sensor.status_tampered.after_update do |status_tampered|
  if status_tampered == 0
    puts "leak sensor status_tampered not tampered"
  elsif status_tampered == 1
    puts "leak sensor status_tampered tampered"
  end
end

leak_sensor.status_fault.after_update do |status_fault|
  if status_fault == 0
    puts "leak sensor status_fault no fault"
  elsif status_fault == 1
    puts "leak sensor status_fault general fault"
  end
end

leak_sensor.status_active.after_update do |active|
  if active
    puts "leak sensor is active"
  else
    puts "leak sensor is inactive"
  end
end

Thread.new do
  sleep 30

  loop do
    leak_sensor.leak_detected = (0..1).to_a.sample
    leak_sensor.status_low_battery = (0..1).to_a.sample
    leak_sensor.status_tampered = (0..1).to_a.sample
    leak_sensor.status_fault = (0..1).to_a.sample
    leak_sensor.status_active = [true, false].to_a.sample

    sleep 10
  end
end

RubyHome.run
