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

    def logged_in?(request)
      if request.header.has_key?('uuid')
        session = current_session(request)

        if session.nil? || session.expired?
          false
        else
          true
        end
      else
        false
      end
    end

    def current_user(request)
      session = current_session(request)

      if session.nil?
        nil
      else
        session.user
      end
    end

    def current_session(request)
      if request.header.has_key?('uuid')
        uuid = request.header['uuid'].first
        Session.find_by(uuid: uuid, remote_ip: request.remote_ip)
      else
        nil
      end
    end
  end
end