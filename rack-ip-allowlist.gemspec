# -*- mode: ruby -*-
# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rack-ip-allowlist/version"

Gem::Specification.new do |s|
  s.name        = "rack-ip-allowlist"
  s.version     = Rack::Ip::Allowlist::VERSION
  s.authors     = ["Jake Varghese, William Wedler"]
  s.email       = ["jake3030@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Ip Allowlist middleware}
  s.description = %q{Rack middleware to quickly add ip allowlisting to your app}

  s.rubyforge_project = "rack-ip-allowlist"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency(%q<netaddr>, ["~> 1.5.0"])
  s.add_development_dependency "rake"
  s.add_development_dependency(%q<rspec>, ["~> 3.0.0"])
  s.add_development_dependency(%q<rack>, ["~> 1.5.2"])
end
