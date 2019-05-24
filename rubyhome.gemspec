
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_home/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_home'
  spec.version       = RubyHome::VERSION
  spec.authors       = ['Karl Entwistle']
  spec.email         = ['karl@entwistle.com']
  spec.summary       = 'Ruby HomeKit support'
  spec.description   = <<~DESCRIPTION
    RubyHome is a lightweight service you can run on your home network that
    emulates the iOS HomeKit API. It supports community contributed plugins, which
    are modules that provide a bridge from HomeKit to various 3rd-party APIs
    provided by manufacturers of smart home devices.
  DESCRIPTION
  spec.homepage      = 'https://github.com/karlentwistle/ruby_home'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = ['ruby_home']
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.4.1'

  spec.add_dependency 'bindata', '~> 2.4', '>= 2.4.3'
  spec.add_dependency 'dnssd', '~> 3.0'
  spec.add_dependency 'facets', '~> 3.1'
  spec.add_dependency 'hkdf', '~> 0.3.0'
  spec.add_dependency 'oj', '3.7.12'
  spec.add_dependency 'rbnacl', '~> 7.0'
  spec.add_dependency 'ruby_home-srp', '~> 1.3'
  spec.add_dependency 'ruby_home-tlv', '~> 0.1.0'
  spec.add_dependency 'sinatra', '2.0.5'
  spec.add_dependency 'wisper', '~> 2.0'

  spec.add_development_dependency 'byebug', '~> 11.0'
  spec.add_development_dependency 'plist', '~> 3.4'
  spec.add_development_dependency 'rack-test', '~> 1.1.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
