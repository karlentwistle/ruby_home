require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
contact_sensor = RubyHome::ServiceFactory.create(:contact_sensor,
  contact_sensor_state: 0, # required
  name: "contact sensor", # optional
  status_low_battery: 0, # optional
  status_tampered: 0, # optional
  status_fault: 0, # optional
  status_active: true # optional
)

contact_sensor.contact_sensor_state.after_update do |contact_sensor_state|
  if contact_sensor_state == 0
    puts "contact sensor contact sensor state contact detected"
  elsif contact_sensor_state == 1
    puts "contact sensor contact sensor state contact not detected"
  end
end

contact_sensor.status_low_battery.after_update do |status_low_battery|
  if status_low_battery == 0
    puts "contact sensor low battery is battery level normal"
  elsif status_low_battery == 1
    puts "contact sensor low battery is battery level low"
  end
end

contact_sensor.status_tampered.after_update do |status_tampered|
  if status_tampered == 0
    puts "contact sensor status_tampered not tampered"
  elsif status_tampered == 1
    puts "contact sensor status_tampered tampered"
  end
end


contact_sensor.status_fault.after_update do |status_fault|
  if status_fault == 0
    puts "contact sensor status_fault no fault"
  elsif status_fault == 1
    puts "contact sensor status_fault general fault"
  end
end

contact_sensor.status_active.after_update do |active|
  if active
    puts "contact sensor is active"
  else
    puts "contact sensor is inactive"
  end
end

Thread.new do
  sleep 30

  loop do
    contact_sensor.contact_sensor_state = (0..1).to_a.sample
    contact_sensor.status_low_battery = (0..1).to_a.sample
    contact_sensor.status_tampered = (0..1).to_a.sample
    contact_sensor.status_fault = (0..1).to_a.sample
    contact_sensor.status_active = [true, false].to_a.sample

    sleep 10
  end
end

RubyHome.run
