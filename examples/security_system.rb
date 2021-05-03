require "ruby_home"

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
security_system = RubyHome::ServiceFactory.create(:security_system,
  security_system_target_state: 0, # required
  security_system_current_state: 0, # required
  name: "security system", # optional
  security_system_alarm_type: 0, # optional
  status_tampered: 0, # optional
  status_fault: 0) # optional

security_system_target_state_values = {
  0 => "Stay Arm",
  1 => "Away Arm",
  2 => "Night Arm",
  3 => "Disarm"
}
security_system.security_system_target_state.after_update do |security_system_target_state|
  state = security_system_target_state_values[security_system_target_state]
  puts "security system security_system_target_state #{state}"
  sleep 1
  security_system.security_system_current_state = security_system_target_state
end

security_system_current_state_values = {
  0 => "Stay Arm",
  1 => "Away Arm",
  2 => "Night Arm",
  3 => "Disarmed",
  4 => "Alarm Triggered"
}
security_system.security_system_current_state.after_update do |security_system_current_state|
  state = security_system_current_state_values[security_system_current_state]
  puts "security system security_system_current_state state #{state}"
end

security_system.status_tampered.after_update do |status_tampered|
  if status_tampered == 0
    puts "security system status_tampered not tampered"
  elsif status_tampered == 1
    puts "security system status_tampered tampered"
  end
end

security_system.status_fault.after_update do |status_fault|
  if status_fault == 0
    puts "security system status_fault no fault"
  elsif status_fault == 1
    puts "security system status_fault general fault"
  end
end

RubyHome.run
