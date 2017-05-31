module YugiohX2
  class HTTPError < YugiohError
    attr_reader :response_code

    def initialize(response_code, message)
      super("ResponseCode #{response_code} : #{message}")
      @response_code = response_code
    end
  end
end
