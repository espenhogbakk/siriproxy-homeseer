# SiriProxy Homeseer plugin

Beware this is in very early stages of development. This is not very stable 
and it does not include a lot of functionality yet.

## Installation

Add this to your SiriProxy config file, which should live in `~/.siriproxy/config.yml`

    - name: 'Homeseer'
      git: 'git://github.com/espenhogbakk/siriproxy-homeseer.git'
      host: '192.168.1.50' 

The `host` argument should be the IP or hostname of the server running the Homeseer
software.

This plugin relies on the Nokogiri ruby gem, which should be installed automatically but 
if it fails, read the [installation instructions](http://nokogiri.org/tutorials/installing_nokogiri.html) 
for nokogiri as it has some dependencies.

It also relies on the only HTTP accessible API i found for Homeseer which works, but is kind 
a crap since it returns results in HTML format, which need parsing. You need to install TenHsServer 
on the Homeseer server.

http://www.tenholder.net/tenware2/tenHsServer/installation.aspx

If someone knows about a better HTTP API for Homeseer that don't require HTML parsing that 
would be awesome, as the dependency on Nokogiri could be removed.

## Usage

This plugin supports the following commands:


* Turn on [device] *in *the [room]
* Turn off [device] *in *the [room]
* Turn on [device|room] *lights
* Turn off [device|room] *lights
* Turn on *the lights
* Turn off *the lights
* Run event [event]

Words marked with * are optional.

For the commands "Turn on/off *the lights" to work, you need to have an event in Homeseer 
with the name "all off" and "all on".
