require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
outlet = RubyHome::ServiceFactory.create(:outlet,
  outlet_in_use: false, # required
  on: false, # required
  name: "occupancy sensor", # optional
)

outlet.outlet_in_use.after_update do |outlet_in_use|
  if outlet_in_use
    puts "outlet in use"
  else
    puts "outlet not in use"
  end
end

outlet.on.after_update do |on|
  if on
    puts "outlet is on"
    sleep 1
    outlet.outlet_in_use = true
  else
    puts "outlet is off"
    sleep 1
    outlet.outlet_in_use = false
  end
end

RubyHome.run
