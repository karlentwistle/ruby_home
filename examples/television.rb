require 'ruby_home'

RubyHome.configure do |c|
  c.discovery_name = 'Television'
  c.category_identifier = :television
end

accessory = RubyHome::Accessory.new

RubyHome::ServiceFactory.create(:accessory_information,
  accessory: accessory, # required
)

television = RubyHome::ServiceFactory.create(:television,
  accessory: accessory, # required
  primary: true, # required
  configured_name: 'Television', # required
  active: 1, # required
  active_identifier: 1, # required
  sleep_discovery_mode: 1, # required
  remote_key: nil, # required
  name: 'Television', # optional
  power_mode_selection: true, # optional
  picture_mode: 4, # optional
  target_media_state: 0, # optional
  current_media_state: 0, # optional
  brightness: 100 # optional
)

television.active.after_update do |active|
  if active == 0
    puts "television is inactive"
  else
    puts "television is active"
  end
end

television.active_identifier.after_update do |active_identifier|
  puts "television active input source #{active_identifier}"
end

television.remote_key.after_update do |remote_key|
  puts "television remote_key #{remote_key}"
end

speaker = RubyHome::ServiceFactory.create(:television_speaker,
  accessory: accessory, # required
  mute: false, # required
  name: "Television Volume", # optional
  active: 1, # optional
  volume_control_type: 1, # optional
  volume_selector: 0, # optional
)
speaker.volume_selector.after_update do |volume|
  if volume == 0
    puts "television volume up"
  else
    puts "television volume down"
  end
end

sources = (1..4).map do |index|
  RubyHome::ServiceFactory.create(:input_source,
    accessory: accessory, # required
    subtype: "source#{index}", # required
    name: "Source #{index}", # required
    configured_name: "Source #{index}", # required
    input_source_type: 3, # required
    is_configured: 1, # required
    current_visibility_state: 0, # required
    identifier: index, # optional
    input_device_type: 1 # optional

  )
end
television.linked = [speaker] + sources

RubyHome.run
