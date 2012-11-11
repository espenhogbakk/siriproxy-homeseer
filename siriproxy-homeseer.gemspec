# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-homeseer"
  s.version     = "0.0.1" 
  s.authors     = ["espenhogbakk"]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = %q{A Siri Proxy Plugin to controll Homeseer}
  s.description = %q{This is Siri Proxy plugin. Which can be used to controll events and devies in Homeseer. It requires tenHsServer to work. }

  s.rubyforge_project = "siriproxy-homeseer"

  s.files         = `git ls-files 2> /dev/null`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/* 2> /dev/null`.split("\n")
  s.executables   = `git ls-files -- bin/* 2> /dev/null`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
