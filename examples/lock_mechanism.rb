require "ruby_home"

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
lock_mechanism = RubyHome::ServiceFactory.create(:lock_mechanism,
  lock_target_state: 1, # required
  lock_current_state: 1, # required
  name: "lock") # optional

lock_mechanism.lock_target_state.after_update do |lock_target_state|
  if lock_target_state == 0
    puts "lock target state is unsecured"

    sleep 1
    lock_mechanism.lock_current_state = 0
  elsif lock_target_state == 1
    puts "lock target state is secured"

    sleep 1
    lock_mechanism.lock_current_state = 1
  end
end

lock_current_state_values = {
  0 => "Unsecured",
  1 => "Secured",
  2 => "Jammed",
  3 => "Unknown"
}
lock_mechanism.lock_current_state.after_update do |lock_current_state|
  state = lock_current_state_values[lock_current_state]
  puts "lock current state #{state}"
end

RubyHome.run
