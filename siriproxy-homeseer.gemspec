# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-homeseer"
  s.version     = "0.1.0" 
  s.authors     = ["Espen Høgbakk"]
  s.email       = ["espen@hogbakk.no"]
  s.homepage    = ""
  s.summary     = %q{A Siri Proxy Plugin to controll Homeseer}
  s.description = %q{This is Siri Proxy plugin. Which can be used to controll events and devies in Homeseer. It requires tenHsServer to work. }

  s.rubyforge_project = "siriproxy-homeseer"

  s.files         = `git ls-files 2> /dev/null`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/* 2> /dev/null`.split("\n")
  s.executables   = `git ls-files -- bin/* 2> /dev/null`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "ten_hs_server", "~> 0.2.0"
end
