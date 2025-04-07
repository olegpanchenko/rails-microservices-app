module Authorization
  extend ActiveSupport::Concern

  included do
    before_action :authorize_user
    attr_reader :current_user
  end

  def authorize_user
    token = request.headers["Authorization"].presence

    return render_unauthorized if token.nil?

    token = token.gsub(/Bearer\s*/, "").strip

    begin
      payload = JWT.decode(token, Rails.application.secret_key_base).first
      @current_user = AuthService::GetUser.new(token, payload["id"]).call
    rescue JWT::DecodeError => e
      debugger
      render_unauthorized
    end
  end

  private
  def token
    request.headers["Authorization"].gsub(/Bearer/, "").strip
  end

  def render_unauthorized
    render json: { errors: [ title: "Unauthorized", code: 401, status: 401 ] }, status: :unauthorized
  end
end
