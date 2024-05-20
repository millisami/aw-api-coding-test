class ApplicationController < ActionController::API
  before_action :snake_case_params
  before_action :authenticated!

  def current_user
    @current_user = User.find_by(id: payload[0]['user_id'])
  end

  def authenticated!
    return unauthenticated if !payload || !AuthTokenService.valid_payload(payload.first)
    current_user
    unauthenticated unless @current_user
  end

  private

  def payload
    header = request.headers['Authorization']
    if header
      token = header.split(' ').last
      begin
        AuthTokenService.decode(token)
      rescue StandardError
        nil
      end
    end
  end

  def unauthenticated
    render json: { message: "You are not logged in."}, status: :unauthorized
  end

  def snake_case_params
    request.parameters.deep_transform_keys!(&:underscore)
  end
end
