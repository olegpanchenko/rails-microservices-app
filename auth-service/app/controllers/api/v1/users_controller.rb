class Api::V1::UsersController < Api::V1::ApplicationController
  skip_before_action :authorize_user, only: %i[create]

  def index
    render json: User.all
  end

  def create
    attributes = process_params[:data][:attributes]
    user = User.create!(email: attributes[:email], password: attributes[:password], password_confirmation: attributes[:password])

    render json: user
  end

  def show
    user = User.find(params[:id])
    render json: user
  end

  private
  def process_params
    params.permit(
      data: [
        :id,
        :type,
        attributes: [
          :email,
          :password
        ]
      ]
    )
  end
end
