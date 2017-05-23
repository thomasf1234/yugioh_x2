#!/usr/bin/env ruby
# https://www.igvita.com/2007/02/13/building-dynamic-webrick-servers-in-ruby/
# http://flylib.com/books/en/2.44.1.244/1/
require_relative '../application'
require "webrick"

=begin
WEBrick is a Ruby library that makes it easy to build an HTTP server with Ruby.
It comes with most installations of Ruby by default (it’s part of the standard library),
so you can usually create a basic web/HTTP server with only several lines of code.
The following code creates a generic WEBrick server on the local machine on port 1234,
shuts the server down if the process is interrupted (often done with Ctrl+C).
This example lets you call the URL's: "add" and "subtract" and pass through arguments to them
Example usage:
GET curl "localhost:2000/cards/search?uuid=fd9bf307-90e3-4bdf-bf38-29ae911766d0&name=Dark%20Magician"
POST curl -H "Content-Type: application/json" -X POST -d '{"some":"xyz","more":"abc"}' localhost:2000/
=end


if ENV['DAEMON']
  #redirect stdout and stderr to log
  $stdout.reopen("log/server.log", "w")
  $stdout.sync = true
  $stderr.reopen($stdout)
  WEBrick::Daemon.start
end

server = WEBrick::HTTPServer.new(RequestCallback: lambda(&YugiohX2::WebrickServlet.method(:before_request)), Port: 2000)

server.mount "/", YugiohX2::WebrickServlet

['INT', 'TERM'].each do |signal|
  trap(signal) do
    server.shutdown
  end
end

server.start