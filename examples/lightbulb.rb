require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
lightbulb = RubyHome::ServiceFactory.create(:lightbulb,
  on: true, # required
  name: "lightbulb", # optional
  brightness: 100, # optional
  saturation: 100, # optional
  hue: 360 # optional
)

lightbulb.on.after_update do |on|
  if on
    puts "lightbulb is off"
  else
    puts "lightbulb is on"
  end
end

lightbulb.brightness.after_update do |brightness|
  puts "lightbulb is at #{brightness} brightness"
end

lightbulb.saturation.after_update do |saturation|
  puts "lightbulb is at #{saturation} saturation"
end

lightbulb.hue.after_update do |hue|
  puts "lightbulb is at #{hue} hue"
end


RubyHome.run
