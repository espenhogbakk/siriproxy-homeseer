require 'cora'
require 'siri_objects'
require 'pp'
require 'ten_hs_server'

#######
# Plugin to control Homeseer automation software.
######

class SiriProxy::Plugin::Homeseer < SiriProxy::Plugin
  attr_accessor :host, :client

  def initialize(config = {})
    self.host = config['host']
    self.client = TenHsServer.new host
  end

  # Running an event
  listen_for /run event (.*)/i do |event|
    say "Running event #{event}."
    event = client.event.run event
    request_completed
  end

  # Turn on/off all lights
  listen_for /turn (on|off)(?: the)? lights/i do |action|
    if action == 'on'
      say "Lights on."
      event = client.event.run "All on"
    else
      say "Lights off."
      event = client.event.run "All off"
    end
    request_completed
  end

  # Turn on/off a device in a specified room
  listen_for /turn (on|off)(?: the)? ([a-z]* ?[a-z]*) in(?: the)? ([a-z]* ?[a-z]*)/i do |action, device_name, room_name|
    rooms = client.room.all
    room = rooms.find {|room| room.name.downcase == room_name.downcase.strip}

    run_action_on_device action, room.devices, device_name
    request_completed
  end

  # Turn on/off a device or a room
  listen_for /turn (on|off)(?: the)? ([a-z]* ?[a-z]*)/i do |action, name|
    name = name.downcase.strip
    devices = client.device.all
    devices = devices.find_all {|device| device.name.downcase == name}
    
    # If we couldn't find any devices, try finding a room with that name
    if devices.empty?
      rooms = client.room.all
      room = rooms.find {|room| room.name.downcase == name}
      if room
        if action == 'on'
          room.on
        else
          room.off
        end
        say "Turning #{action} #{name}."
      else
        say "Sorry, I couldn't find any devices, or rooms by that name."
      end
    else
      run_action_on_device action, devices, name
    end

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
        # TODO Implement a way to ask the user which device he meant.
        #options = devices.map { |device| device.id }
        #device_id = ask "Hey, I found more than one device by that name, please choose which "\
        #    "one you want to turn #{action}.", options: options
        #device = devices.find {|device| device.id == device_id }
        device = devices[0]
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
