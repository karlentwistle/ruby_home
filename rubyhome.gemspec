
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubyhome/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubyhome'
  spec.version       = Rubyhome::VERSION
  spec.authors       = ['Karl Entwistle']
  spec.email         = ['karl@entwistle.com']
  spec.summary       = 'Ruby HomeKit support'
  spec.description   = <<~DESCRIPTION
    RubyHome is a lightweight service you can run on your home network that
    emulates the iOS HomeKit API. It supports community contributed plugins, which
    are modules that provide a bridge from HomeKit to various 3rd-party APIs
    provided by manufacturers of smart home devices.
  DESCRIPTION
  spec.homepage      = 'https://github.com/karlentwistle/rubyhome'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '~> 5.1', '>= 5.1.4'
  spec.add_dependency 'dnssd', '~> 3.0'
  spec.add_dependency 'ed25519', '~> 1.2', '>= 1.2.3'
  spec.add_dependency 'hkdf', '~> 0.3.0'
  spec.add_dependency 'rbnacl', '~> 5.0'
  spec.add_dependency 'rbnacl-libsodium', '~> 1.0', '>= 1.0.16'
  spec.add_dependency 'sinatra', '~> 2.0'
  spec.add_dependency 'sqlite3', '~> 1.3', '>= 1.3.13'
  spec.add_dependency 'x25519', '~> 1.0', '>= 1.0.5'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug', '~> 9.1'
  spec.add_development_dependency 'rack-test', '~> 0.8.2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
