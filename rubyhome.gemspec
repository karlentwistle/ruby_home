
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

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bindata', '~> 2.4', '>= 2.4.3'
  spec.add_dependency 'dnssd', '~> 3.0'
  spec.add_dependency 'ed25519', '~> 1.2', '>= 1.2.3'
  spec.add_dependency 'hkdf', '~> 0.3.0'
  spec.add_dependency 'oj', '~> 3.4'
  spec.add_dependency 'rbnacl', '~> 5.0'
  spec.add_dependency 'rbnacl-libsodium', '~> 1.0', '>= 1.0.16'
  spec.add_dependency 'ruby_home-srp', '~> 1.2'
  spec.add_dependency 'sinatra', '2.0.3'
  spec.add_dependency 'wisper', '~> 1.6', '>= 1.6.1'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug', '~> 10.0'
  spec.add_development_dependency 'plist', '~> 3.4'
  spec.add_development_dependency 'rack-test', '~> 1.0.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
