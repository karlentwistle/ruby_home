require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
fan = RubyHome::ServiceFactory.create(:fan_v2,
  active: true, # required
  name: "fan", # optional
  swing_mode: 1, # optional
  rotation_speed: 0, # optional
  rotation_direction: 0, # optional
  lock_physical_controls: 0, # optional
  target_fan_state: 0, # optional
  current_fan_state: 0 # optional
)

fan.active.after_update do |active|
  if active == 0
    puts "fan is inactive"
  elsif active == 1
    puts "fan is active"
  end
end

fan.swing_mode.after_update do |swing_mode|
  if swing_mode == 0
    puts "fan swing is enabled"
  elsif swing_mode == 1
    puts "fan swing is disabled"
  end
end

fan.rotation_speed.after_update do |rotation_speed|
  puts "fan is spinning at #{rotation_speed} speed"
end

fan.rotation_direction.after_update do |rotation_direction|
  if rotation_direction == 0
    puts "fan rotating clockwise"
  elsif rotation_direction == 1
    puts "fan rotating counter clockwise"
  end
end

fan.lock_physical_controls.after_update do |lock_physical_controls|
  if lock_physical_controls == 0
    puts "fan control lock disabled"
  elsif lock_physical_controls == 1
    puts "fan control lock enabled"
  end
end

fan.target_fan_state.after_update do |target_fan_state|
  if target_fan_state == 0
    puts "fan target fan state manual"
  elsif target_fan_state == 1
    puts "fan target fan state auto"
  end
end

fan.current_fan_state.after_update do |current_fan_state|
  if current_fan_state == 0
    puts "fan current fan state inactive"
  elsif current_fan_state == 1
    puts "fan current fan state idle"
  elsif current_fan_state == 2
    puts "fan current fan state blowing air"
  end
end

RubyHome.run
