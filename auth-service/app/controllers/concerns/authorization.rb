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
      payload = Authorization::JsonWebToken.decode(token)
      @current_user = User.find(payload["id"])
    rescue StandardError => e
      render_unauthorized
    end
  end

  private
  def render_unauthorized
    render json: { errors: [ title: "Unauthorized", detail: "Unauthorized. Invalid or expired token.", code: 401, status: 401 ] }, status: :unauthorized
  end
end
