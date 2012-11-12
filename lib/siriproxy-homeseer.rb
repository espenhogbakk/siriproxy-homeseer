require 'cora'
require 'siri_objects'
require 'pp'
require 'httparty'
require 'open-uri'
require 'nokogiri'

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
    run_event(event)
  end

  listen_for /turn off(?: the)? lights/i do
    say "Lights off."
    run_event('all off')
  end

  listen_for /turn on(?: the)? lights/i do
    say "Lights on."
    run_event('all on')
  end
  
  #listen_for /turn on ([a-z]*)(?: in)?(?: the)? ([a-z]*)/i do |device, location|
  #  say "Turning on #{device}."
  #  device_code = get_device_code(device, location)
  #  device_on(device_code)
  #end

  listen_for /turn on ([a-z]*)(?: lights)?/i do |device|
    say "Turning on #{device}."
    device_code = get_device_code(device, nil)
    begin
      puts "Code " + device_code
    rescue
      puts "No code"
    end    
    device_on(device_code)
  end

  listen_for /turn off ([a-z]*)(?: lights)?/i do |device|
    say "Turning off #{device}."
    device_code = get_device_code(device, nil)
    begin
      puts "Code " + device_code
    rescue
      puts "No code"
    end
    device_off(device_code)
  end

  def run_event(event)
    event = URI::encode(event.rstrip)
    page = HTTParty.get("http://#{self.host}/tenHsServer/tenHsServer.aspx?t=ab&f=RunEvent&d=#{event}").body rescue nil
    request_completed
  end

  def device_on(device)
    if device
      page = HTTParty.get("http://#{self.host}/tenHsServer/tenHsServer.aspx?t=ab&f=DeviceOn&d=#{device}").body rescue nil
    end
    request_completed
  end

  def device_off(device)
    if device
      page = HTTParty.get("http://#{self.host}/tenHsServer/tenHsServer.aspx?t=ab&f=DeviceOff&d=#{device}").body rescue nil
    end
    request_completed
  end

  def get_device_code(device_name, location)
    # Get the string inside <span id="Result">
    # split that string into an array on ";"
    # Convert all the elements to 'Device' objects
    # loop through the devices
      # if we find a match for the device name
        # add it to the list of found devices
      
    # If there is more than one found device
      # If there is no location specified (make sure that is optional)
        # Ask for location
      # else
        # Use given location
          # return device code
    # else
      # return device code

    html = HTTParty.get("http://#{self.host}/tenHsServer/tenHsServer.aspx?t=ab&f=GetDevices").body rescue nil
    doc = Nokogiri::HTML(html)

    device_strings = doc.xpath('//span[@id="Result"]')[0].content.split(";")
    devices = []
    device_strings.each do |device_string|
      d = device_string.split(":")
      device = Device.new(d[0], d[1], d[2], d[3].downcase, d[4])
      devices.push(device)
    end

    if location
      matches = Device.find_by_name_and_location(device_name, location)
    else
      matches = Device.find_by_name(device_name)
    end
    
    begin
      matches[0].code
    rescue
      nil
    end
  end

  class Device
    attr_accessor :code, :type, :name, :location, :location2
    def initialize(code, type, location, name, location2)
      @code = code
      @type = type
      @name = name
      @location = location
      @location2 = location2
    end

    def to_s
      @location2 + " " + @name
    end

    def self.find_by_name(name)
      devices = []
      ObjectSpace.each_object(Device) { |o|
        if o.name == name
          devices.push(o)
        end
      }
      devices
    end

    def self.find_by_name_and_location(name, location)
      devices = []
      ObjectSpace.each_object(Device) { |o|
        if o.name == name and o.location == location
          devices.push(o)
        end
      }
      devices
    end
  end

end

