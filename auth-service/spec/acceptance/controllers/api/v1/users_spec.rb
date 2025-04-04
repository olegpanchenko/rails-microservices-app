require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'support/shared_contexts/api/parameters'
require 'support/shared_contexts/api/response_fields'
require 'support/shared_contexts/api/errors'

resource 'Users' do
  explanation "Users resource"

  header "Content-Type", "application/json"
  authentication :apiKey, :authorization_token, name: 'Authorization', description: 'Authorization header JWT Token'

  get "/api/v1/users" do
    route_summary "List Users"
    route_description "Retrieve a list of users."

    let(:users) { FactoryBot.create_list(:user, 3) }

    context "when the Authorization token is invalid" do
      let(:authorization_token) { "invalid_token" }
      let(:errors_json) { { title: "Unauthorized", detail: "Unauthorized. Invalid or expired token.", code: 401, status: 401 }.to_json }

      example_request "Unauthorized access" do
        expect(response_status).to eq(401)
        expect(response_body).to be_json_eql(errors_json).at_path("errors/0")
      end
    end

    context "when the Authorization token is valid" do
      let(:current_user) { FactoryBot.create(:user) }

      let(:authorization_token) { Authorization::JsonWebToken.encode(id: current_user.id, email: current_user.email) }

      context "when users exist" do
        # Response Fields
        response_field :data, 'Data', type: :array, items: {
          type: :object,
          title: 'Users Data',
          properties: {
            id: { type: :string, description: 'User ID' },
            type: { type: :string, description: 'Resource type (e.g., user)' },
            attributes: {
              type: :object,
              description: 'User attributes',
              properties: {
                email: { type: :string, description: 'User email' }
              }
            }
          }
        }

        example_request "Successfully retrieved list of users" do
          expect(response_status).to eq(200)
          expect(response_body).to have_json_path("data")
          expect(response_body).to be_json_eql(current_user.id.to_s.to_json).at_path("data/0/id")
          expect(response_body).to be_json_eql(current_user.email.to_json).at_path("data/0/attributes/email")
        end
      end

      context "when no users exist" do
        let(:users) { [] }

        let(:data) {
          [
            {
              "attributes": {
                "email": current_user.email
              },
              "type": "users"
            }
          ]
        }

        example_request "No users found" do
          expect(response_status).to eq(200)
          expect(response_body).to have_json_path("data")
          expect(response_body).to be_json_eql(data.to_json).at_path("data")
        end
      end
    end
  end

  get "/api/v1/users/:id" do
    route_summary "Get User Details"
    route_description "Retrieve details of a user by ID."

    let(:id) { user.id }
    let(:email) { "user@example.com" }
    let(:user) { FactoryBot.create(:user, email: email) }

    context "when the Authorization token is invalid" do
      # Response Fields
      include_context "errors response field"

      let(:authorization_token) { "invalid_token" }
      let(:errors_json) { { title: "Unauthorized", detail: "Unauthorized. Invalid or expired token.", code: 401, status: 401 }.to_json }

      example_request "Unauthorized access" do
        expect(response_status).to eq(401)
        expect(response_body).to be_json_eql(errors_json).at_path("errors/0")
      end
    end

    context "when the Authorization token is valid" do
      let(:authorization_token) { Authorization::JsonWebToken.encode(id: user.id, email: user.email) }

      context "to a non-existing user" do
        # Response Fields
        include_context "errors response field"

        let(:id) { 2 }
        let(:errors_json) { { title: "Record not found", code: 404, status: 404 }.to_json }

        example_request "User not found" do
          expect(response_status).to eq(404)
          expect(response_body).to be_json_eql(errors_json).at_path("errors/0")
        end
      end

      context "to an existing user" do
        # Response Fields
        include_context "data link response fields"

        with_options scope: [ :data, :attributes ] do
          response_field :email, "Email", type: :string
        end

        example_request "Successfully retrieved user details" do
          expect(response_status).to eq(200)
          expect(response_body).to have_json_path("data/id")
          expect(response_body).to have_json_path("data/attributes/email")
          expect(response_body).to be_json_eql(user.id.to_s.to_json).at_path("data/id")
          expect(response_body).to be_json_eql(user.email.to_json).at_path("data/attributes/email")
        end
      end
    end
  end

  post "/api/v1/users" do
    route_summary "Create a User"
    route_description "Creates a new user with provided email and password."

    with_options scope: :data, with_example: true do
      parameter :type, "Resource type", required: true
    end
    with_options scope: [ :data, :attributes ], with_example: true do
      parameter :email, "User email", required: true
      parameter :password, "User password", required: true
    end

    let(:raw_post) { params.to_json }
    let(:type) { 'accounts' }

    context "with valid parameters" do
      let(:email) { "user@example.com" }
      let(:password) { "secretpassword" }

      # Response Fields
      response_field :data, 'Data', type: :object, properties: {
        id: { type: :string, description: 'User ID' },
        type: { type: :string, description: 'Resource type (e.g., user)' },
        attributes: {
          type: :object,
          description: 'User attributes',
          properties: {
            email: { type: :string, description: 'User email' }
          }
        }
      }

      example_request 'Successfully created user' do
        expect(response_status).to eq(200)
        expect(response_body).to have_json_path("data/id")
        expect(response_body).to have_json_path("data/attributes/email")
      end
    end

    context "with invalid parameters" do
      let(:email) { "user@example.com" }
      let(:password) { "secretpassword" }
      let!(:user) { FactoryBot.create(:user, email: email) }

      example_request 'Failed user creation (email already taken)' do
        expect(response_status).to eq(422)
        expect(response_body).to have_json_path("errors")
      end
    end
  end
end
