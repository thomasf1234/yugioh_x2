module YugiohX2
  class BaseController
    def healthcheck(request)
      render json: {message: "Service is online"}.to_json
    end

    protected
    def valid_params?(query, keys)
      query.keys.sort == keys.sort
    end

    def extract_payload(request)
      case request.content_type
        when "application/json"
          JSON.parse(request.body)
        else
          request.body
      end
    end

    def render(params, response_code=200)
      if params.has_key?(:json)
        [params[:json], response_code]
      else
        raise "Only json response is supported"
      end
    end

    def logged_in?(uuid, remote_ip)
      session = current_session(uuid, remote_ip)

      if session.nil? || session.expired?
        false
      else
        true
      end
    end

    def current_user(uuid, remote_ip)
      session = current_session(uuid, remote_ip)
      session.user
    end

    def current_session(uuid, remote_ip)
      Session.find_by(uuid: uuid, remote_ip: remote_ip)
    end
  end
end