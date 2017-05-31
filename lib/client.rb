module YugiohX2Lib
  require 'net/http'
  require 'json'

  class Client
    def initialize(url='http://localhost:2000')
      @url = url
    end

    def healthcheck
      get('/healthcheck')
    end

    def db_names
      get('/cards/db_names')
    end

    def card(db_name)
      get("/cards/get?db_name=#{db_name}")
    end

    def login(username, password)
      response_body = post('/login', { username: username, password: password })
      @uuid = response_body["uuid"]
    end

    def logout
      post('/logout')
    end

    def user
      get('/users/get')
    end

    def user_cards
      get('/users/cards')
    end

    def password_machine(serial_number)
      post('/shops/password_machine', {serial_number: serial_number})
    end

    protected
    def get(endpoint)
      uri = URI.parse(@url + endpoint)
      request = Net::HTTP::Get.new(uri.request_uri, 'Accept' => 'application/json')
      request["uuid"] = @uuid
      response = http(uri).request(request)
      validate_response(response)
      JSON.parse(response.body)
    end

    def post(endpoint, body={})
      uri = URI.parse(@url + endpoint)
      request = Net::HTTP::Post.new(uri.request_uri,
                                    'Accept' => 'application/json',
                                    'Content-Type' => 'application/json')
      request["uuid"] = @uuid
      request.body = body.to_json
      response = http(uri).request(request)
      validate_response(response)
      JSON.parse(response.body)
    end

    def http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = 30
      http
    end

    def validate_response(response)
      if response.code != '200'
        raise YugiohX2::HTTPError.new(response.code, JSON.parse(response.body)['message'])
      end
    end
  end
end