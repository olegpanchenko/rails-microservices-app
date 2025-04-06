module Authorization
  class JsonWebToken
    class << self
      def encode(payload)
        JWT.encode(payload.merge(expire: 10.hours.from_now.to_i), Rails.application.secret_key_base)
      end

      def decode(token)
        JWT.decode(token, Rails.application.secret_key_base).first
      end
    end
  end
end
