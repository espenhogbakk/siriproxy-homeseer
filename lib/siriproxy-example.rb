require 'cora'
require 'siri_objects'
require 'pp'

#######
# Plugin to control Homeseer automation software.
######

class SiriProxy::Plugin::Homeseer < SiriProxy::Plugin
  def initialize(config)
    #if you have custom configuration options, process them here!
  end

  listen_for /run event (.*)/i do |event|
    say "You want to run event: #{event}"
  end
end
