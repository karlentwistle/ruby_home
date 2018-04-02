[![Maintainability](https://api.codeclimate.com/v1/badges/c81f4cfdf5c13d716487/maintainability)](https://codeclimate.com/github/karlentwistle/ruby_home/maintainability)
[![Build Status](https://travis-ci.org/karlentwistle/ruby_home.svg?branch=master)](https://travis-ci.org/karlentwistle/ruby_home)

# ruby_home

ruby_home is an implementation of the HomeKit Accessory Protocol (HAP) to create your own HomeKit accessory in Ruby. HomeKit is a set of protocols and libraries to access devices for Home Automation. A non-commercial version of the protocol documentation is available on the [HomeKit developer website](https://developer.apple.com/homekit/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_home'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_home

## Usage

Create a fan with an on/off switch.

```ruby
require 'ruby_home'

accessory_information = RubyHome::AccessoryFactory.create(:accessory_information)
fan = RubyHome::AccessoryFactory.create(:fan)

fan.characteristic(:on).on(:updated) do |new_value|
  if new_value == 1
    puts "Fan switched on"
  else
    puts "Fan switched off"
  end
end

RubyHome::Broadcast.run
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ruby_home.
