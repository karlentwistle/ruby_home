require "ruby_home"

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
door = RubyHome::ServiceFactory.create(:door,
  target_position: 0, # required
  position_state: 1, # required
  current_position: 0, # required
  name: "door", # optional
  obstruction_detected: false) # optional

door.target_position.after_update do |target_position|
  puts "door target position #{target_position}"

  if target_position < door.current_position
    door.position_state = 0
  elsif target_position > door.current_position
    door.position_state = 1
  end

  sleep 1

  door.current_position = target_position
  door.position_state = 2
end

position_state_values = {
  0 => "Decreasing",
  1 => "Increasing",
  2 => "Stopped"
}
door.position_state.after_update do |position_state|
  state = position_state_values[position_state]
  puts "door position state #{state}"
end

door.current_position.after_update do |current_position|
  puts "door current position #{current_position}"
end

door.obstruction_detected.after_update do |obstruction_detected|
  if obstruction_detected
    puts "door obstruction detected"
  else
    puts "door no obstruction detected"
  end
end

RubyHome.run
