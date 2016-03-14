# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ci_overhead/version'

Gem::Specification.new do |spec|
  spec.name          = "ci_overhead"
  spec.version       = CiOverhead::VERSION
  spec.authors       = ["Kris Kumler"]
  spec.email         = ["kris@triceimaging.com"]

  spec.summary       = %q{Some helpers for things we need from CI.}
  spec.description   = %q{CI helpers. Unless you work with us, you won't care one bit.}
  spec.homepage      = "https://github.com/trice-imaging/ci_overhead"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec-core", "~> 3.0"
  spec.add_dependency "rspec_junit_formatter", "~> 0.2"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end
