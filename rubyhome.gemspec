
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rubyhome/version"

Gem::Specification.new do |spec|
  spec.name          = "rubyhome"
  spec.version       = Rubyhome::VERSION
  spec.authors       = ["Karl Entwistle"]
  spec.email         = ["karl@entwistle.com"]
  spec.summary       = "Ruby HomeKit support"
  spec.description   = <<~DESCRIPTION
    RubyHome is a lightweight service you can run on your home network that
    emulates the iOS HomeKit API. It supports community contributed plugins, which
    are modules that provide a bridge from HomeKit to various 3rd-party APIs
    provided by manufacturers of smart home devices.
  DESCRIPTION
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dnssd", "~> 3.0"
  spec.add_dependency "sinatra", "~> 2.0"
  spec.add_dependency "thin", "~> 1.7", ">= 1.7.2"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
