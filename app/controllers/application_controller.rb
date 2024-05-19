class ApplicationController < ActionController::API
  before_action :authenticated!

  def encode_token(payload)
    JWT.encode(payload, 'my_strong_key_8848')
  end

  def decoded_token
    header = request.headers['Authorization']
    if header
      token = header.split(" ")[1]
      begin
        JWT.decode(token, 'my_strong_key_8848')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def authenticated!
    unless !!current_user
      render json: { message: "You are not logged in."}, status: :unauthorized
    end
  end
end
