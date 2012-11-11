require 'cora'
require 'siri_objects'
require 'pp'
require 'httparty'

#######
# Plugin to control Homeseer automation software.
######

class SiriProxy::Plugin::Homeseer < SiriProxy::Plugin
  attr_accessor :host

  def initialize(config = {})
    self.host = config["host"]
  end

  listen_for /run event (.*)/i do |event|
    run_event(event)
  end

  def run_event(event)
    say "One moment while I run the event #{event}."

    Thread.new {
      page = HTTParty.get("http://#{self.host}/tenHsServer/tenHsServer.aspx?t=ab&f=RunEvent&d=#{event}").body rescue nil
      say "There you go..."
      request_completed #always complete your request! Otherwise the phone will "spin" at the user!
    }

  end

end
