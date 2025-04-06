class Api::V1::TokensController < Api::V1::ApplicationController
  skip_before_action :authorize_user

  def create
    user = User.find_by(email: process_params[:email])

    if user.present? && user.authenticate(process_params[:password])
      token = Authorization::JsonWebToken.encode({ id: user.id, email: user.email })
      render json: { token: token }
    else
      render json: { errors: [ title: "Invalid email or password", code: 401, status: 401 ] }, status: :unauthorized
    end
  end

  private
  def process_params
    params.permit(
      :email,
      :password
    )
  end
end
