require "webrick"

module YugiohX2
  class WebrickServlet < WEBrick::HTTPServlet::AbstractServlet
    def do_GET (request, response)
      process(request, response)
    end

    def do_POST (request, response)
      process(request, response)
    end

    def self.before_request(request, response)
      #before_request_hook
    end

    private
    def process(request, response)
      response.content_type = "application/json"
      route = request.path

      http_method = request.request_method
      if ROUTES[http_method].has_key?(route)
        controller_klass = Object.const_get(ROUTES[http_method][route])
        controller = controller_klass.new
        controller_method = route.match(/[^\/]*$/).to_s.to_sym

        if controller_klass.instance_methods.include?(controller_method)
          json_body, response_code = controller.send(controller_method, request)
          response.body = json_body
          response.status = response_code
        else
          raise NoMethodError.new("#{controller_klass.name}##{controller_method}")
        end
      else
        response.status = 404
      end
    end
  end
end