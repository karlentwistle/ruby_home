require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
fan = RubyHome::ServiceFactory.create(:fan,
  on: false, # required
  name: "fan", # optional
  rotation_speed: 50, # optional
  rotation_direction: 0 # optional
)

fan.on.after_update do |on|
  if on
    puts "fan is on"
  else
    puts "fan is off"
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

RubyHome.run
