require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
humidifier_dehumidifier = RubyHome::ServiceFactory.create(:humidifier_dehumidifier,
  active: 1, # required
  target_humidifier_dehumidifier_state: 0, # required
  current_humidifier_dehumidifier_state: 1, # required
  current_relative_humidity: 30, # required
  name: "humidifier dehumidifier", # optional
  rotation_speed: 0, # optional
  relative_humidity_humidifier_threshold: 100, # optional
  relative_humidity_dehumidifier_threshold: 0, # optional
  water_level: 50, # optional
  swing_mode: 1, # optional
  lock_physical_controls: 0, # optional
)

humidifier_dehumidifier.active.after_update do |active|
  if active == 0
    puts "humidifier dehumidifier is inactive"
  elsif active == 1
    puts "humidifier dehumidifier is active"
  end
end

target_humidifier_dehumidifier_state_values = {
  0 => 'Humidifier or Dehumidifier',
  1 => 'Humidifier',
  2 => 'Dehumidifier'
}
humidifier_dehumidifier.target_humidifier_dehumidifier_state.after_update do |target_humidifier_dehumidifier_state|
  state = target_humidifier_dehumidifier_state_values[target_humidifier_dehumidifier_state]
  puts "humidifier dehumidifier target humidifier dehumidifier state is #{state}"
end

current_humidifier_dehumidifier_state_values = {
  0 => 'Inactive',
  1 => 'Idle',
  2 => 'Humidifying',
  3 => 'Dehumidifying'
}
humidifier_dehumidifier.current_humidifier_dehumidifier_state.after_update do |current_humidifier_dehumidifier_state|
  state = current_humidifier_dehumidifier_state_values[current_humidifier_dehumidifier_state]
  puts "humidifier dehumidifier target humidifier dehumidifier state is #{state}"
end

humidifier_dehumidifier.current_relative_humidity.after_update do |current_relative_humidity|
  puts "humidifier dehumidifier current relative humidity at #{current_relative_humidity}"
end

humidifier_dehumidifier.rotation_speed.after_update do |rotation_speed|
  puts "humidifier dehumidifier is spinning at #{rotation_speed} speed"
end

humidifier_dehumidifier.relative_humidity_humidifier_threshold.after_update do |relative_humidity_humidifier_threshold|
  # maximum_value: 100
  # minimum_value: 0
  # step_value: 1
  puts "humidifier dehumidifier relative humidity humidifier threshold temperature #{relative_humidity_humidifier_threshold}"
end

humidifier_dehumidifier.relative_humidity_dehumidifier_threshold.after_update do |relative_humidity_dehumidifier_threshold|
  # maximum_value: 100
  # minimum_value: 0
  # step_value: 1
  puts "humidifier dehumidifier relative humidity humidifier threshold temperature #{relative_humidity_dehumidifier_threshold}"
end

humidifier_dehumidifier.water_level.after_update do |water_level|
  puts "humidifier dehumidifier water level #{water_level}"
end

humidifier_dehumidifier.swing_mode.after_update do |swing_mode|
  if swing_mode == 0
    puts "humidifier dehumidifier swimg is disabled"
  elsif swing_mode == 1
    puts "humidifier dehumidifier swimg is enabled"
  end
end

humidifier_dehumidifier.lock_physical_controls.after_update do |lock_physical_controls|
  if lock_physical_controls == 0
    puts "humidifier dehumidifier control lock disabled"
  elsif lock_physical_controls == 1
    puts "humidifier dehumidifier control lock enabled"
  end
end

RubyHome.run
