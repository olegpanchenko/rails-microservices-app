module AuthService
  class GetUser
    include HTTParty
    base_uri "http://localhost:8888/api/v1"

    def initialize(token, user_id)
      @token = token
      @user_id = user_id
    end

    def call
      response = self.class.get("/users/#{@user_id}", headers: { Authorization: @token })
      if response.success?
        payload = response.parsed_response
        User.new(id: payload["data"]["id"], email: payload["data"]["attributes"]["email"])
      else
        nil
      end
    end
  end
end
