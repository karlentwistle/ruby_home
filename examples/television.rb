require 'ruby_home'

RubyHome.configure do |c|
  c.discovery_name = 'Television'
  c.category_indentifier = 26
end

accessory = RubyHome::Accessory.new

RubyHome::ServiceFactory.create(:accessory_information,
  accessory: accessory,
)

television = RubyHome::ServiceFactory.create(:television,
  accessory: accessory,
  primary: true,
  name: 'Television',
  configured_name: 'Television',
  active: 1,
  active_identifier: 1,
  sleep_discovery_mode: 1,
  remote_key: nil
)
television.remote_key.valid_values = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 15]
television.active.after_update do |active|
  puts "active = #{active}"
end
television.active_identifier.after_update do |active_identifier|
  puts "active_identifier = #{active_identifier}"
end
television.remote_key.after_update do |remote_key|
  puts "remote_key = #{remote_key}"
end

speaker = RubyHome::ServiceFactory.create(:television_speaker,
  accessory: accessory,
  name: "Television Volume",
  active: 1,
  mute: 0,
  volume_control_type: 1,
  volume_selector: 0
)
speaker.volume_selector.valid_values = [0, 1]
speaker.volume_selector.after_update do |value|
  puts "volume #{value == 0 ? "up" : "down"}"
end

sources = (1..4).map do |index|
  RubyHome::ServiceFactory.create(:input_source,
    accessory: accessory,
    identifier: index,
    subtype: "source#{index}",
    name: "Source #{index}",
    configured_name: "Source #{index}",
    input_source_type: 3,
    is_configured: 1,
    current_visibility_state: 0
  )
end
television.linked = [speaker] + sources

RubyHome.run
