require 'rails_helper'

resource 'Token' do
  explanation "Token resource"

  header "Content-Type", "application/json"

  post "/api/v1/token" do
    route_summary "Token"
    route_description "Generate token for user."

    with_options with_example: true do
      parameter :email, "User email", required: true
      parameter :password, "User password", required: true
    end

    let(:raw_post) { params.to_json }

    context "with valid credentials" do
      let(:email) { "user@example.com" }
      let(:password) { "secretpassword" }
      let!(:user) { FactoryBot.create(:user, email: email, password: password, password_confirmation: password) }

      example_request 'Successfully generated token' do
        expect(response_status).to eq(200)
        expect(response_body).to have_json_path("token")
      end
    end

    context "with invalid credentials" do
      let(:email) { "user@example.com" }
      let(:password) { "secretpassword" }

      describe "wrong email" do
        example_request 'Failed token creation (wrong email)' do
          expect(response_status).to eq(401)
          expect(response_body).to include("Invalid email or password")
        end
      end

      describe "wrong password" do
        let!(:user) { FactoryBot.create(:user, email: email) }

        example_request 'Failed token creation (wrong password)' do
          expect(response_status).to eq(401)
          expect(response_body).to include("Invalid email or password")
        end
      end
    end
  end
end
