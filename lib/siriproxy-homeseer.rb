require 'cora'
require 'siri_objects'
require 'pp'
#require 'open-uri'
require 'ten_hs_server'

#######
# Plugin to control Homeseer automation software.
######

class SiriProxy::Plugin::Homeseer < SiriProxy::Plugin
  attr_accessor :host

  def initialize(config = {})
    self.host = config["host"]
  end

  listen_for /run event (.*)/i do |event|
    say "Running event #{event}."
    event = TenHsServer::Event.run event
    request_completed
  end

  listen_for /turn off(?: the)? lights/i do
    say "Lights off."
    event = TenHsServer::Event.run "All off"
    request_completed
  end

  listen_for /turn on(?: the)? lights/i do
    say "Lights on."
    event = TenHsServer::Event.run "All on"
    request_completed
  end
  
  #listen_for /turn on ([a-z]*)(?: in)?(?: the)? ([a-z]*)/i do |device, location|
  #  say "Turning on #{device}."
  #  device_code = get_device_code(device, location)
  #  device_on(device_code)
  #end

  listen_for /turn (on|off) ([a-z]*)(?: lights)?/i do |command, device_name|
    devices = TenHsServer::Device.all
    devices = devices.find_all {|device| device.name.downcase == device_name.downcase}
    if devices.empty?
      say "Sorry, I couldn't find any devices by that name."
    else
      if devices.length > 1
        say "Hey, I found more than one device by that name, please choose which one you want to turn #{command}."
      else
        device = devices[0]
      end
    end

    if device
      if command == 'on'
        device.on
      else
        device.off
      end
      say "Turning #{command} #{device_name}."
    end
    request_completed
  end

end
