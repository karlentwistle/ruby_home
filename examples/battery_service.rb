require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
battery_service = RubyHome::ServiceFactory.create(:battery_service,
  status_low_battery: 0, # required
  charging_state: 0, # required
  battery_level: 20, # required
  name: "battery service", # optional
)

battery_service.status_low_battery.after_update do |status_low_battery|
  if status_low_battery == 0
    puts "battery service status low battery is battery level normal"
  elsif status_low_battery == 1
    puts "battery service status low battery is battery level low"
  end
end

battery_service.charging_state.after_update do |charging_state|
  if charging_state == 0
    puts "battery service charging state is not charging"
  elsif charging_state == 1
    puts "battery service charging state is charging"
  elsif charging_state == 2
    puts "battery service charging state is not chargeable"
  end
end

battery_service.battery_level.after_update do |battery_level|
  puts "battery service battery level #{battery_level}"

  if battery_level < 10 && battery_service.status_low_battery != 1
    battery_service.status_low_battery = 1
  end

  if battery_level > 11 && battery_service.status_low_battery != 0
    battery_service.status_low_battery = 0
  end
end

Thread.new do
  sleep 30

  loop do
    battery_service.charging_state = 0
    while battery_service.battery_level > 0
      battery_service.battery_level -= 1
      sleep 1
    end

    battery_service.charging_state = 1
    while battery_service.battery_level < 101
      battery_service.battery_level += 1
      sleep 1
    end
  end
end

RubyHome.run
