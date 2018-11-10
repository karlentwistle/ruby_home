[![Maintainability](https://api.codeclimate.com/v1/badges/c81f4cfdf5c13d716487/maintainability)](https://codeclimate.com/github/karlentwistle/ruby_home/maintainability)
[![Build Status](https://travis-ci.org/karlentwistle/ruby_home.svg?branch=master)](https://travis-ci.org/karlentwistle/ruby_home)

# ruby_home

ruby_home is an implementation of the HomeKit Accessory Protocol (HAP) to create your own HomeKit accessory in Ruby. HomeKit is a set of protocols and libraries to access devices for home automation. A non-commercial version of the protocol documentation is available on the [HomeKit developer website](https://developer.apple.com/homekit/).

## Installation

### libsodium

To use ruby_home, you will need to install libsodium:

https://github.com/jedisct1/libsodium

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

## Basic Usage

Create a fan with an on/off switch.

```ruby
require 'ruby_home'

accessory_information = RubyHome::ServiceFactory.create(:accessory_information)
fan = RubyHome::ServiceFactory.create(:fan)

fan.characteristic(:on).after_update do |characteristic|
  if characteristic.value == 1
    puts "Fan switched on"
  else
    puts "Fan switched off"
  end
end

RubyHome.run
```

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
  if characteristic.value == 1
    puts "Fan switched on"
  else
    puts "Fan switched off"
  end
end

RubyHome.run
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/karlentwistle/ruby_home.
