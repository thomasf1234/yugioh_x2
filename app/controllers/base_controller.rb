module YugiohX2
  class BaseController
    def healthcheck(request)
      render json: {message: "Service is online"}
    end

    def login(request)
      username = request.query["username"]
      password = request.query["password"]

      if User.exists?(username: username)
        user = User.find_by_username(username)
        encrypted_password = User.encrypt_password(username, password)

        if encrypted_password == user.encrypted_password
          render json: {message: "Service is online"}
        else
          render json: {message: "Service is online"}, 400
        end
      end
    end

    protected
    def render(params, response_code=200)
      if params.has_key?(:json)
        [params[:json], response_code]
      else
        raise "Only json response is supported"
      end
    end
  end
end