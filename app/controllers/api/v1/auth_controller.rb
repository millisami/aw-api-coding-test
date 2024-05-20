module Api::V1
  class AuthController < ApplicationController
    skip_before_action :authenticated!, only: [:signin]
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def signin
      @user = User.find_by!(email: signin_params[:auth][:email])
      if @user.authenticate(signin_params[:auth][:password])
        render json: V1::UserSerializer.new(@user), status: :accepted
      else
        render json: { error: 'Incorrect password' }, status: :unauthorized
      end
    end

    private
    
    def signin_params
      params.permit(auth: [:email, :password])
    end

    def record_not_found(e)
      render json: { error: "Email doesn not exist" }, status: :unauthorized
    end
  end
end
