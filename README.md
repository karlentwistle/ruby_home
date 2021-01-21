[![Maintainability](https://api.codeclimate.com/v1/badges/c81f4cfdf5c13d716487/maintainability)](https://codeclimate.com/github/karlentwistle/ruby_home/maintainability)

# ruby_home

ruby_home is an implementation of the HomeKit Accessory Protocol (HAP) to create your own HomeKit accessory in Ruby. HomeKit is a set of protocols and libraries to access devices for home automation. A non-commercial version of the protocol documentation is available on the [HomeKit developer website](https://developer.apple.com/homekit/).

## Installation

### libsodium

To use ruby_home, you will need to install [libsodium](https://github.com/jedisct1/libsodium):

At least version `1.0.9` is required.

For OS X users, libsodium is available via homebrew and can be installed with:

    brew install libsodium

For Debian users, libsodium is available via apt:

    sudo apt-get install libsodium-dev

### ruby_home

Add this line to your application's Gemfile:

```ruby
gem 'ruby_home'
```

And then execute:

    $ bundle

Or install it yourself with:

    $ gem install ruby_home

## Basic usage

Create a fan with an on/off switch:

```ruby
require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
fan = RubyHome::ServiceFactory.create(:fan)

fan.on.after_update do |updated_value|
  if updated_value
    puts "Fan switched on"
  else
    puts "Fan switched off"
  end
end

RubyHome.run
```

## Examples

The following example services are available:

### Sensors
- [Air quality sensor](https://github.com/karlentwistle/ruby_home/blob/master/examples/air_quality_sensor.rb)
- [Carbon dioxide sensor](https://github.com/karlentwistle/ruby_home/blob/master/examples/carbon_dioxide_sensor.rb)
- [Carbon monoxide sensor](https://github.com/karlentwistle/ruby_home/blob/master/examples/carbon_monoxide_sensor.rb)
- [Contact sensor](https://github.com/karlentwistle/ruby_home/blob/master/examples/contact_sensor.rb)
- [Humidity sensor](https://github.com/karlentwistle/ruby_home/blob/master/examples/humidity_sensor.rb)
- [Leak sensor](https://github.com/karlentwistle/ruby_home/blob/master/examples/leak_sensor.rb)
- [Light sensor](https://github.com/karlentwistle/ruby_home/blob/master/examples/light_sensor.rb)
- [Motion sensor](https://github.com/karlentwistle/ruby_home/blob/master/examples/motion_sensor.rb)
- [Occupancy sensor](https://github.com/karlentwistle/ruby_home/blob/master/examples/occupancy_sensor.rb)
- [Smoke sensor](https://github.com/karlentwistle/ruby_home/blob/master/examples/smoke_sensor.rb)
- [Temperature sensor](https://github.com/karlentwistle/ruby_home/blob/master/examples/temperature_sensor.rb)

### Controlables 
- [Air purifier](https://github.com/karlentwistle/ruby_home/blob/master/examples/air_purifier.rb)
- [Battery service](https://github.com/karlentwistle/ruby_home/blob/master/examples/battery_service.rb)
- [Door](https://github.com/karlentwistle/ruby_home/blob/master/examples/door.rb)
- [Fan](https://github.com/karlentwistle/ruby_home/blob/master/examples/fan.rb)
- [Fan V2](https://github.com/karlentwistle/ruby_home/blob/master/examples/fan_v2.rb)
- [Garage door opener](https://github.com/karlentwistle/ruby_home/blob/master/examples/garage_door_opener.rb)
- [Heater cooler](https://github.com/karlentwistle/ruby_home/blob/master/examples/heater_cooler.rb)
- [Humidifier dehumidifier](https://github.com/karlentwistle/ruby_home/blob/master/examples/humidifier_dehumidifier.rb)
- [Lightbulb](https://github.com/karlentwistle/ruby_home/blob/master/examples/lightbulb.rb)
- [Lock mechanism](https://github.com/karlentwistle/ruby_home/blob/master/examples/lock_mechanism.rb)
- [Outlet](https://github.com/karlentwistle/ruby_home/blob/master/examples/outlet.rb)
- [Security system](https://github.com/karlentwistle/ruby_home/blob/master/examples/security_system.rb)
- [Switch](https://github.com/karlentwistle/ruby_home/blob/master/examples/switch.rb)
- [Thermostat](https://github.com/karlentwistle/ruby_home/blob/master/examples/thermostat.rb)
- [Window](https://github.com/karlentwistle/ruby_home/blob/master/examples/window.rb)
- [Window covering](https://github.com/karlentwistle/ruby_home/blob/master/examples/window_covering.rb)


## Configuration

The configuration options can be set by using the `configure` helper:

```ruby
RubyHome.configure do |c|
  c.discovery_name = 'My Home'
end
```

The following is the full list of available configuration options:

| Method | Description | Default | Example | Type |
|---|---|---|---|---|
| `discovery_name` |  The user-visible name of the accessory | `"RubyHome"` | `"My Home"` | String |
| `model_name` |  The model name of the accessory | `"RubyHome"` | `"Device1,1"` | String |
| `password` | Used for pairing, must conform to the format XXX-XX-XXX where each X is a 0-9 digit and dashes are required | Randomly generated | `"101-48-005"` | String |
| `host` | The hostname or IP address of the interface to listen on | `"0.0.0.0"` | `"192.168.0.2"` | String  |
| `port` | The port that should be used when starting the built-in web server | `4567` | `8080` | Integer |

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

fan.on.after_update do |updated_value|
  if updated_value
    puts "Fan switched on"
  else
    puts "Fan switched off"
  end
end

RubyHome.run
```

## Updating a characteristics value

If you have a service with characteristics that can be changed outside of Ruby Home, you'll want to keep Ruby Home in sync with these modifications. Otherwise, the characteristics current value won't correspond with reality. The simplest way to do this is a background job that periodically polls the devices current status and updates the corresponding characteristics value if it's changed.

Given a fan which can be switched on / off with a remote control, which has a JSON API endpoint at http://example.org/fan_status.json that returns its current status `{ "on": true }` or `{ "on": false }`, we can spawn a thread that keeps polling the fans current status and if it's changed update our fan service "on" characteristic.

```ruby
require 'json'
require 'open-uri'
require 'ruby_home'

fan = RubyHome::ServiceFactory.create(:fan)

Thread.new do
  def fetch_fan_status
    json = JSON.load(open("http://example.org/fan_status.json"))
    json["on"]
  end

  loop do
    sleep 10 # seconds

    current_fan_status = fetch_fan_status

    unless fan.on == current_fan_status
      fan.on = current_fan_status
    end
  end
end

RubyHome.run
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/karlentwistle/ruby_home.
