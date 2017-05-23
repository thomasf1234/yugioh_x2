#!/usr/bin/env ruby
# https://www.igvita.com/2007/02/13/building-dynamic-webrick-servers-in-ruby/
# http://flylib.com/books/en/2.44.1.244/1/
require_relative '../application'
require "webrick"
require 'json'

=begin
WEBrick is a Ruby library that makes it easy to build an HTTP server with Ruby.
It comes with most installations of Ruby by default (it’s part of the standard library),
so you can usually create a basic web/HTTP server with only several lines of code.
The following code creates a generic WEBrick server on the local machine on port 1234,
shuts the server down if the process is interrupted (often done with Ctrl+C).
This example lets you call the URL's: "add" and "subtract" and pass through arguments to them
Example usage:
http://localhost:1234/ (this will show the specified error message)
http://localhost:1234/add?a=10&b=10
http://localhost:1234/subtract?a=10&b=9
=end

class MyServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET (request, response)
    response.content_type = "application/json"
    route = request.path

    if ROUTES["GET"].has_key?(route)
      controller_klass = Object.const_get(ROUTES["GET"][route])
      controller = controller_klass.new
      controller_method = route.match(/[^\/]*$/).to_s.to_sym

      if controller_klass.instance_methods.include?(controller_method)
        json_body, response_code = controller.send(controller_method, request)
        response.body = json_body
        response.status = response_code
      else

      end
    else
      response.status = 404
    end
  end
end

if ENV['DAEMON']
  #redirect stdout and stderr to log
  $stdout.reopen("log/server.log", "w")
  $stdout.sync = true
  $stderr.reopen($stdout)
  WEBrick::Daemon.start
end


server = WEBrick::HTTPServer.new(RequestCallback: lambda(&YugiohX2::BaseController.method(:before_request)), Port: 2000)

server.mount "/", MyServlet

['INT', 'TERM'].each do |signal|
  trap(signal) do
    server.shutdown
  end
end

server.start