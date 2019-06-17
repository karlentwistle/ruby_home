require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
air_quality_sensor = RubyHome::ServiceFactory.create(:air_quality_sensor,
  air_quality: 0, # required
  name: "air quality sensor", # optional
  carbon_dioxide_level: 0, # optional
  carbon_monoxide_level: 0, # optional
  voc_density: 0, # optional
  pm10_density: 0, # optional
  pm2_5_density: 0, # optional
  sulphur_dioxide_density: 0, # optional
  nitrogen_dioxide_density: 0, # optional
  ozone_density: 0, # optional
  status_low_battery: 0, # optional
  status_tampered: 0, # optional
  status_fault: 0, # optional
  status_active: true # optional
)

air_quality_values = {
  0 => 'Unknown',
  1 => 'Excellent',
  2 => 'Good',
  3 => 'Fair',
  4 => 'Inferior',
  5 => 'Poor'
}
air_quality_sensor.air_quality.after_update do |air_quality|
  state = air_quality_values[air_quality]
  puts "air quality sensor air quality is #{state}"
end

air_quality_sensor.carbon_dioxide_level.after_update do |carbon_dioxide_level|
  puts "air quality sensor carbon_dioxide_level #{carbon_dioxide_level}"
end

air_quality_sensor.carbon_monoxide_level.after_update do |carbon_monoxide_level|
  puts "air quality sensor carbon_monoxide_level #{carbon_monoxide_level}"
end

air_quality_sensor.voc_density.after_update do |voc_density|
  puts "air quality sensor voc_density #{voc_density}"
end

air_quality_sensor.pm10_density.after_update do |pm10_density|
  puts "air quality sensor pm10_density #{pm10_density}"
end

air_quality_sensor.pm2_5_density.after_update do |pm2_5_density|
  puts "air quality sensor pm2_5_density #{pm2_5_density}"
end

air_quality_sensor.sulphur_dioxide_density.after_update do |sulphur_dioxide_density|
  puts "air quality sensor sulphur_dioxide_density #{sulphur_dioxide_density}"
end

air_quality_sensor.nitrogen_dioxide_density.after_update do |nitrogen_dioxide_density|
  puts "air quality sensor nitrogen_dioxide_density #{nitrogen_dioxide_density}"
end

air_quality_sensor.ozone_density.after_update do |ozone_density|
  puts "air quality sensor ozone_density #{ozone_density}"
end

air_quality_sensor.status_low_battery.after_update do |status_low_battery|
  if status_low_battery == 0
    puts "air quality sensor battery level normal"
  elsif status_low_battery == 1
    puts "air quality sensor battery level lormal"
  end
end

air_quality_sensor.status_tampered.after_update do |status_tampered|
  if status_tampered == 0
    puts "air quality sensor status_tampered not tampered"
  elsif status_tampered == 1
    puts "air quality sensor status_tampered tampered"
  end
end

air_quality_sensor.status_fault.after_update do |status_fault|
  if status_fault == 0
    puts "air quality sensor status_fault no fault"
  elsif status_fault == 1
    puts "air quality sensor status_fault general fault"
  end
end

air_quality_sensor.status_active.after_update do |active|
  if active
    puts "air quality sensor is active"
  else
    puts "air quality sensor is inactive"
  end
end

Thread.new do
  sleep 30

  loop do
    air_quality_sensor.air_quality = air_quality_values.keys.sample
    air_quality_sensor.carbon_dioxide_level = (0..100000).to_a.sample
    air_quality_sensor.carbon_monoxide_level = (0..100).to_a.sample
    air_quality_sensor.voc_density = (0..1000).to_a.sample
    air_quality_sensor.pm10_density = (0..1000).to_a.sample
    air_quality_sensor.pm2_5_density = (0..1000).to_a.sample
    air_quality_sensor.sulphur_dioxide_density = (0..1000).to_a.sample
    air_quality_sensor.nitrogen_dioxide_density = (0..1000).to_a.sample
    air_quality_sensor.ozone_density = (0..1000).to_a.sample
    air_quality_sensor.status_low_battery = (0..1).to_a.sample
    air_quality_sensor.status_tampered = (0..1).to_a.sample
    air_quality_sensor.status_fault = (0..1).to_a.sample
    air_quality_sensor.status_active = [true, false].to_a.sample

    sleep 10
  end
end

RubyHome.run
