require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
garage_door_opener = RubyHome::ServiceFactory.create(:garage_door_opener,
  obstruction_detected: false, # required
  target_door_state: 1, # required
  current_door_state: 1, # required
  name: "garage door opener", # optional
  lock_target_state: 1, # optional
  lock_current_state: 1, # optional
)

garage_door_opener.obstruction_detected.after_update do |obstruction_detected|
  if obstruction_detected
    puts "garage door opener obstruction detected"
  else
    puts "garage door opener no obstruction detected"
  end
end

target_door_state_values = {
  0 => 'Open',
  1 => 'Closed',
}
garage_door_opener.target_door_state.after_update do |target_door_state|
  state = target_door_state_values[target_door_state]
  puts "garage door opener target door state is #{state}"

  if target_door_state == 0
    garage_door_opener.current_door_state = 2
    sleep 1
    garage_door_opener.current_door_state = 0
  elsif target_door_state == 1
    garage_door_opener.current_door_state = 3
    sleep 1
    garage_door_opener.current_door_state = 1
  end
end

current_door_state_values = {
  0 => 'Open',
  1 => 'Closed',
  2 => 'Opening',
  3 => 'Closing',
  4 => 'Stopped'
}
garage_door_opener.current_door_state.after_update do |current_door_state|
  state = current_door_state_values[current_door_state]
  puts "garage door opener current door state door state is #{state}"
end

garage_door_opener.lock_target_state.after_update do |lock_target_state|
  if lock_target_state == 0
    puts "garage door opener lock target state is unsecured"
  elsif lock_target_state == 1
    puts "garage door opener lock target state is secured"
  end
end

garage_door_opener.lock_current_state.after_update do |lock_current_state|
  if lock_current_state == 0
    puts "garage door opener lock current state is unsecured"
  elsif lock_current_state == 1
    puts "garage door opener lock current state is secured"
  elsif lock_current_state == 2
    puts "garage door opener lock current state is jammed"
  elsif lock_current_state == 3
    puts "garage door opener lock current state is unknown"
  end
end

RubyHome.run
