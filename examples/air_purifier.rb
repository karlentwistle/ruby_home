require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
air_purifier = RubyHome::ServiceFactory.create(:air_purifier,
  target_air_purifier_state: 0, # required
  current_air_purifier_state: 0, # required
  active: 0, # required
  name: "air_purifier", # optional
  rotation_speed: 0, # optional
  swing_mode: 1, # optional
  lock_physical_controls: 0, # optional
)

air_purifier.target_air_purifier_state.after_update do |target_air_purifier_state|
  if target_air_purifier_state == 0
    puts "air purifier target air purifier state disabled"
  elsif target_air_purifier_state == 1
    puts "air purifier target air purifier state enabled"
  end
end

air_purifier.current_air_purifier_state.after_update do |current_air_purifier_state|
  if current_air_purifier_state == 0
    puts "air purifier current air purifier state is inactive"
  elsif current_air_purifier_state == 1
    puts "air purifier current air purifier state is idle"
  elsif current_air_purifier_state == 2
    puts "air purifier current air purifier state is purifying air"
  end
end

air_purifier.active.after_update do |active|
  if active == 0
    puts "air purifier is inactive"
    air_purifier.target_air_purifier_state = 0
    sleep 1
    air_purifier.current_air_purifier_state = 0
  elsif active == 1
    puts "air purifier is active"
    air_purifier.target_air_purifier_state = 1
    sleep 1
    air_purifier.current_air_purifier_state = 2
  end
end

air_purifier.swing_mode.after_update do |swing_mode|
  if swing_mode == 0
    puts "air purifier swing is enabled"
  elsif swing_mode == 1
    puts "air purifier swing is disabled"
  end
end

air_purifier.rotation_speed.after_update do |rotation_speed|
  puts "air_purifier is spinning at #{rotation_speed} speed"
end

air_purifier.lock_physical_controls.after_update do |lock_physical_controls|
  if lock_physical_controls == 0
    puts "air purifier control lock disabled"
  elsif lock_physical_controls == 1
    puts "air purifier control lock enabled"
  end
end

RubyHome.run
