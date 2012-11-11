require 'cora'
require 'siri_objects'
require 'pp'
require 'httparty'
require 'open-uri'

#######
# Plugin to control Homeseer automation software.
######

class SiriProxy::Plugin::Homeseer < SiriProxy::Plugin
  attr_accessor :host

  def initialize(config = {})
    self.host = config["host"]
  end

  listen_for /trigger event (.*)/i do |event|
    run_event(event)
  end

  def run_event(event)
    say "One moment while I run the event #{event}."

    Thread.new {
      url = URI::encode('http://#{self.host}/tenHsServer/tenHsServer.aspx?t=ab&f=RunEvent&d=#{event}')
      page = HTTParty.get(url).body rescue nil
      say "There you go..."
      request_completed #always complete your request! Otherwise the phone will "spin" at the user!
    }

  end

end
