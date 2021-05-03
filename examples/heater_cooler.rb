require "ruby_home"

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
heater_cooler = RubyHome::ServiceFactory.create(:heater_cooler,
  current_temperature: 20, # required
  target_heater_cooler_state: 1, # required
  current_heater_cooler_state: 2, # required
  active: 1, # required
  name: "heater cooler", # optional
  rotation_speed: 0, # optional
  temperature_display_units: 0, # optional
  heating_threshold_temperature: 20, # optional
  cooling_threshold_temperature: 10, # optional
  swing_mode: 1, # optional
  lock_physical_controls: 0) # optional

heater_cooler.current_temperature.after_update do |current_temperature|
  puts "heater cooler current temperature in celsius #{current_temperature}"
end

target_heater_cooler_state_values = {
  0 => "Auto",
  1 => "Heat",
  2 => "Cool"
}
heater_cooler.target_heater_cooler_state.after_update do |target_heater_cooler_state|
  state = target_heater_cooler_state_values[target_heater_cooler_state]
  puts "heater cooler target heater cooler state is #{state}"
end

current_heater_cooler_state_values = {
  0 => "Inactive",
  1 => "Idle",
  2 => "Heating",
  3 => "Cooling"
}
heater_cooler.current_heater_cooler_state.after_update do |current_heater_cooler_state|
  state = current_heater_cooler_state_values[current_heater_cooler_state]
  puts "heater cooler target heater cooler state is #{state}"
end

heater_cooler.active.after_update do |active|
  if active == 0
    puts "heater cooler is inactive"
  elsif active == 1
    puts "heater cooler is active"
  end
end

heater_cooler.rotation_speed.after_update do |rotation_speed|
  puts "heater cooler is spinning at #{rotation_speed} speed"
end

heater_cooler.temperature_display_units.after_update do |temperature_display_unit|
  if temperature_display_unit == 0
    puts "heater cooler temperature display units Celsius"
  elsif temperature_display_unit == 1
    puts "heater cooler temperature display units Fahrenheit"
  end
end

heater_cooler.heating_threshold_temperature.after_update do |heating_threshold_temperature|
  # maximum_value: 25
  # minimum_value: 0
  # step_value: 0.1
  puts "heater cooler heating threshold temperature #{heating_threshold_temperature}"
end

heater_cooler.cooling_threshold_temperature.after_update do |cooling_threshold_temperature|
  # maximum_value: 35
  # minimum_value: 10
  # step_value: 0.1
  puts "heater cooler cooling threshold temperature temperature #{cooling_threshold_temperature}"
end

heater_cooler.swing_mode.after_update do |swing_mode|
  if swing_mode == 0
    puts "heater cooler swimg is disabled"
  elsif swing_mode == 1
    puts "heater cooler swimg is enabled"
  end
end

heater_cooler.lock_physical_controls.after_update do |lock_physical_controls|
  if lock_physical_controls == 0
    puts "heater cooler control lock disabled"
  elsif lock_physical_controls == 1
    puts "heater cooler control lock enabled"
  end
end

RubyHome.run
