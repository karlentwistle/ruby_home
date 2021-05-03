require "ruby_home"

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
thermostat = RubyHome::ServiceFactory.create(:thermostat,
  temperature_display_units: 0, # required
  target_temperature: 18, # required
  current_temperature: 18, # required
  target_heating_cooling_state: 0, # required
  current_heating_cooling_state: 0, # required
  name: "thermostat", # optional
  heating_threshold_temperature: 20, # optional
  cooling_threshold_temperature: 10, # optional
  target_relative_humidity: 0, # optional
  current_relative_humidity: 0) # optional

thermostat.temperature_display_units.after_update do |temperature_display_unit|
  if temperature_display_unit == 0
    puts "thermostat temperature display units Celsius"
  elsif temperature_display_unit == 1
    puts "thermostat temperature display units Fahrenheit"
  end
end

thermostat.target_temperature.after_update do |target_temperature|
  puts "thermostat target_temperature #{target_temperature}"

  if target_temperature.to_i > thermostat.current_temperature.to_i
    thermostat.target_heating_cooling_state = 1
  elsif target_temperature < thermostat.current_temperature
    thermostat.target_heating_cooling_state = 2
  elsif target_temperature.to_i == thermostat.current_temperature.to_i
    thermostat.target_heating_cooling_state = 0
  end
end

thermostat.current_temperature.after_update do |current_temperature|
  puts "thermostat current_temperature #{current_temperature}"

  if current_temperature.to_i < thermostat.target_temperature.to_i
    thermostat.target_heating_cooling_state = 1
  elsif current_temperature.to_i > thermostat.target_temperature.to_i
    thermostat.target_heating_cooling_state = 2
  elsif current_temperature.to_i == thermostat.target_temperature.to_i
    thermostat.target_heating_cooling_state = 0
  end
end

target_heating_cooling_state_values = {
  0 => "Off",
  1 => "Heat",
  2 => "Cool",
  3 => "Auto"
}
thermostat.target_heating_cooling_state.after_update do |target_heating_cooling_state|
  state = target_heating_cooling_state_values[target_heating_cooling_state]
  puts "heater cooler target heating cooler state is #{state}"

  return true if thermostat.current_heating_cooling_state == target_heating_cooling_state

  if target_heating_cooling_state == 1
    thermostat.current_heating_cooling_state = 1
  elsif target_heating_cooling_state == 2
    thermostat.current_heating_cooling_state = 2
  elsif target_heating_cooling_state == 0
    thermostat.current_heating_cooling_state = 0
  end
end

current_heating_cooling_state_values = {
  0 => "Off",
  1 => "Heat",
  2 => "Cool"
}
thermostat.current_heating_cooling_state.after_update do |current_heating_cooling_state|
  state = current_heating_cooling_state_values[current_heating_cooling_state]
  puts "heater cooler current heating cooler state is #{state}"
end

thermostat.heating_threshold_temperature.after_update do |heating_threshold_temperature|
  # maximum_value: 25
  # minimum_value: 0
  # step_value: 0.1
  puts "heater cooler heating threshold temperature #{heating_threshold_temperature}"
end

thermostat.cooling_threshold_temperature.after_update do |cooling_threshold_temperature|
  # maximum_value: 35
  # minimum_value: 10
  # step_value: 0.1
  puts "heater cooler cooling threshold temperature temperature #{cooling_threshold_temperature}"
end

thermostat.target_relative_humidity.after_update do |target_relative_humidity|
  puts "thermostat target_relative_humidity #{target_relative_humidity}"
end

thermostat.current_relative_humidity.after_update do |current_relative_humidity|
  puts "thermostat current_relative_humidity #{current_relative_humidity}"
end

Thread.new do
  loop do
    sleep 5

    if thermostat.target_temperature.to_i > thermostat.current_temperature.to_i
      thermostat.current_temperature += 1
    elsif thermostat.target_temperature.to_i < thermostat.current_temperature.to_i
      thermostat.current_temperature -= 1
    end
  end
end

RubyHome.run
