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

  listen_for /turn (on|off)(?: the)? lights/i do |action|
    if action == 'on'
      say "Lights on."
      event = TenHsServer::Event.run "All on"
    else
      say "Lights off."
      event = TenHsServer::Event.run "All off"
    end
    request_completed
  end

  listen_for /turn (on|off) ([a-z]*)(?: in)?(?: the)? ([a-z]*)/i do |action, device_name, location|
    room = TenHsServer::Room.new location

    run_action_on_device action, room.devices, device_name
    request_completed
  end

  listen_for /turn (on|off) ([a-z]*)(?: lights)?/i do |action, device_name|
    devices = TenHsServer::Device.all
    devices = devices.find_all {|device| device.name.downcase == device_name.downcase}

    run_action_on_device action, devices, device_name
    request_completed
  end

  private
  # Run action on a device
  #
  # Takes an array of devices, figures out which one you want
  # to run the action on, and then runs it.
  def run_action_on_device action, devices, device_name
    if devices.empty?
      say "Sorry, I couldn't find any devices by that name."
    else
      if devices.length > 1
        say "Hey, I found more than one device by that name, please choose which one you want to turn #{action}."
      else
        device = devices[0]
      end
    end

    if device
      if action == 'on'
        device.on
      else
        device.off
      end
      say "Turning #{action} #{device_name}."
    end
  end

end
