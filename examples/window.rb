require "ruby_home"

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
window = RubyHome::ServiceFactory.create(:window,
  target_position: 0, # required
  position_state: 1, # required
  current_position: 0, # required
  name: "window", # optional
  obstruction_detected: false) # optional

window.target_position.after_update do |target_position|
  puts "window target position #{target_position}"

  if target_position < window.current_position
    window.position_state = 0
  elsif target_position > window.current_position
    window.position_state = 1
  end

  sleep 1

  window.current_position = target_position
  window.position_state = 2
end

position_state_values = {
  0 => "Decreasing",
  1 => "Increasing",
  2 => "Stopped"
}
window.position_state.after_update do |position_state|
  state = position_state_values[position_state]
  puts "window position state #{state}"
end

window.current_position.after_update do |current_position|
  puts "window current position #{current_position}"
end

window.obstruction_detected.after_update do |obstruction_detected|
  if obstruction_detected
    puts "window obstruction detected"
  else
    puts "window no obstruction detected"
  end
end

RubyHome.run
