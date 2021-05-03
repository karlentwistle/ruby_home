require "ruby_home"

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
window_covering = RubyHome::ServiceFactory.create(:window_covering,
  target_position: 0, # required
  position_state: 1, # required
  current_position: 0, # required
  name: "window_covering", # optional
  obstruction_detected: false, # optional
  current_vertical_tilt_angle: 0, # optional
  target_vertical_tilt_angle: 0, # optional
  current_horizontal_tilt_angle: 0, # optional
  target_horizontal_tilt_angle: 0) # optional

window_covering.target_position.after_update do |target_position|
  puts "window covering target position #{target_position}"

  if target_position < window_covering.current_position
    window_covering.position_state = 0
  elsif target_position > window_covering.current_position
    window_covering.position_state = 1
  end

  sleep 1

  window_covering.current_position = target_position
  window_covering.position_state = 2
end

position_state_values = {
  0 => "Decreasing",
  1 => "Increasing",
  2 => "Stopped"
}
window_covering.position_state.after_update do |position_state|
  state = position_state_values[position_state]
  puts "window covering position state #{state}"
end

window_covering.current_position.after_update do |current_position|
  puts "window covering current position #{current_position}"
end

window_covering.obstruction_detected.after_update do |obstruction_detected|
  if obstruction_detected
    puts "window covering obstruction detected"
  else
    puts "window covering no obstruction detected"
  end
end

window_covering.current_vertical_tilt_angle.after_update do |current_vertical_tilt_angle|
  puts "window covering current_vertical_tilt_angle #{current_vertical_tilt_angle}"
end

window_covering.target_vertical_tilt_angle.after_update do |target_vertical_tilt_angle|
  puts "window covering target_vertical_tilt_angle #{target_vertical_tilt_angle}"
  sleep 1
  window_covering.current_vertical_tilt_angle = target_vertical_tilt_angle
end

window_covering.current_horizontal_tilt_angle.after_update do |current_horizontal_tilt_angle|
  puts "window covering current_horizontal_tilt_angle #{current_horizontal_tilt_angle}"
end

window_covering.target_horizontal_tilt_angle.after_update do |target_horizontal_tilt_angle|
  puts "window covering target_horizontal_tilt_angle #{target_horizontal_tilt_angle}"
  sleep 1
  window_covering.current_horizontal_tilt_angle = target_horizontal_tilt_angle
end

RubyHome.run
