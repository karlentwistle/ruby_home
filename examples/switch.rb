require "ruby_home"

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
switch = RubyHome::ServiceFactory.create(:switch,
  on: false, # required
  name: "switch") # optional

switch.on.after_update do |on|
  if on
    puts "switch is on"
  else
    puts "switch is off"
  end
end

RubyHome.run
