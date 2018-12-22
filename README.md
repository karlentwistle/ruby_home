[![Maintainability](https://api.codeclimate.com/v1/badges/c81f4cfdf5c13d716487/maintainability)](https://codeclimate.com/github/karlentwistle/ruby_home/maintainability)
[![Build Status](https://travis-ci.org/karlentwistle/ruby_home.svg?branch=master)](https://travis-ci.org/karlentwistle/ruby_home)

# ruby_home

ruby_home is an implementation of the HomeKit Accessory Protocol (HAP) to create your own HomeKit accessory in Ruby. HomeKit is a set of protocols and libraries to access devices for home automation. A non-commercial version of the protocol documentation is available on the [HomeKit developer website](https://developer.apple.com/homekit/).

## Installation

### libsodium

To use ruby_home, you will need to install [libsodium](https://github.com/jedisct1/libsodium):

At least version `1.0.9` is required.

For OS X users, libsodium is available via homebrew and can be installed with:

    brew install libsodium

For Debian users, libsodium is available both via apt:

    sudo apt-get install libsodium-dev

### ruby_home

Add this line to your application's Gemfile:

```ruby
gem 'ruby_home'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_home

## Basic usage

Create a fan with an on/off switch.

```ruby
require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
fan = RubyHome::ServiceFactory.create(:fan)

fan.characteristic(:on).after_update do |characteristic|
  if characteristic.value == true
    puts "Fan switched on"
  else
    puts "Fan switched off"
  end
end

RubyHome.run
```

## Customization

RubyHome tries to provide sane defaults for all services. Customization of any of the options is possible.

```ruby
require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information,
  firmware_revision: '4.3.18421',
  manufacturer: 'Fake Company',
  model: 'BSB001',
  name: 'Kickass fan bridge',
  serial_number: 'AB1-UK-A123456'
)

fan = RubyHome::ServiceFactory.create(:fan,
  on: false,
  rotation_speed: 50,
  rotation_direction: 1,
  firmware_revision: '105.0.21169',
  manufacturer: 'Fake Company',
  model: 'LWB006',
  name: 'Kickass fan',
  serial_number: '123-UK-A12345'
)

fan.characteristic(:on).after_update do |characteristic|
  if characteristic.value == true
    puts "Fan switched on"
  else
    puts "Fan switched off"
  end
end

RubyHome.run
```

## Updating a characteristics value

If you have a service with characteristics that can be changed outside of Ruby Home. You'll want to keep Ruby Home in sync with these modifications. Otherwise, the characteristics current value won't correspond with reality. The simplest way to do this is a background job that periodically polls the devices current status and updates the corresponding characteristics value if it's changed.

Given a fan which can be switched on / off with a remote control. Which has a JSON API endpoint at http://example.org/fan_status.json that returns its current status `{ "on": true }` or `{ "on": false }`. We can spawn a thread that keeps polling the fans current status and if its changed update our fan service "on" characteristic.

```ruby
require 'json'
require 'open-uri'
require 'ruby_home'

fan = RubyHome::ServiceFactory.create(:fan)
on_characteristic = fan.characteristic(:on)

Thread.new do
  def fetch_fan_status
    json = JSON.load(open("http://example.org/fan_status.json"))
    json["on"]
  end

  loop do
    sleep 10 # seconds

    current_fan_status = fetch_fan_status

    unless on_characteristic.value == current_fan_status
      on_characteristic.value = current_fan_status
    end
  end
end

RubyHome.run
```

## More examples

Create a garage door opener.

```ruby
require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
door = RubyHome::ServiceFactory.create(:garage_door_opener)

door.characteristic(:target_door_state).after_update do |characteristic|
  if characteristic.value == 0 # open
    sleep 1
    door.characteristic(:current_door_state).value = 0
  elsif characteristic.value == 1 #closed
    sleep 1
    door.characteristic(:current_door_state).value = 1
  end
end

RubyHome.run
```

Create a thermostat.

```ruby
  require 'ruby_home'

  accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
  thermostat = RubyHome::ServiceFactory.create(:thermostat,
    current_heating_cooling_state: 0, # off
    target_heating_cooling_state: 0, # off
    current_temperature: 18,
    target_temperature: 18,
    temperature_display_units: 0
  )

  current_heating_cooling_state = thermostat.characteristic(:current_heating_cooling_state)
  target_heating_cooling_state = thermostat.characteristic(:target_heating_cooling_state)
  current_temperature = thermostat.characteristic(:current_temperature)
  target_temperature = thermostat.characteristic(:target_temperature)
  temperature_display_units = thermostat.characteristic(:temperature_display_units)

  target_temperature.after_update do |characteristic|
    if current_temperature.value < characteristic.value
      target_heating_cooling_state.value = 1 # heat
    elsif current_temperature.value > characteristic.value
      target_heating_cooling_state.value = 2 # cool
    end
  end

  target_heating_cooling_state.after_update do |characteristic|
    if characteristic.value == 1
      current_heating_cooling_state.value = 1  # heat
    elsif characteristic.value == 2
      current_heating_cooling_state.value = 2 # cool
    else
      current_heating_cooling_state.value = 0 # off
    end
  end

  Thread.new do
    loop do
      sleep 5 # seconds

      puts "current_temperature: #{current_temperature.value.to_i}"
      puts "target_temperature: #{target_temperature.value.to_i}"

      if target_temperature.value.to_i > current_temperature.value.to_i
        current_temperature.value += 1
      elsif target_temperature.value.to_i < current_temperature.value.to_i
        current_temperature.value -= 1
      else
        target_heating_cooling_state.value = 3 # auto
      end
    end
  end

  RubyHome.run
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/karlentwistle/ruby_home.
