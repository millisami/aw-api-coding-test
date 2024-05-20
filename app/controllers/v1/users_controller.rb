module V1
  class UsersController < ApplicationController
    skip_before_action :authenticated!, only: [:create]
    rescue_from ActiveRecord::RecordInvalid, with: :invalid_record_handler

    def create
      user = User.create!(user_params)
      render json: V1::UserSerializer.new(user), status: :created
    end

    private
    
    def user_params
      params.permit(:first_name, :last_name, :email, :password, :country)
    end

    def invalid_record_handler(e)
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end
  end
end