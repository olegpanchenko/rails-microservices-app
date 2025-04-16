require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'support/shared_contexts/api/parameters'
require 'support/shared_contexts/api/response_fields'
require 'support/shared_contexts/api/errors'

resource 'Orders' do
  explanation "Operations related to user's orders"

  header "Content-Type", "application/json"
  authentication :apiKey, :authorization_token, name: 'Authorization', description: 'Authorization header JWT Token'

  before do
    allow(AuthService::GetUser).to receive(:new).and_return(double(call: user))
  end

  let(:email) { "user@example.com" }
  let(:user) { User.new(id: 1, email: email) }
  let(:authorization_token) { 'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZW1haWwiOiJ1c2VyQGV4YW1wbGUuY29tIn0.ffW65kPR2X97StY7LNmSgliEkMBnwB2NYgw-9gMtb1Q' }
  let!(:order) { FactoryBot.create(:order, user: user) }

  get "/api/v1/orders" do
    example_request "List user's orders" do
      expect(response_status).to eq(200)
      expect(response_body).to include(order.id.to_s)
    end
  end

  get "/api/v1/orders/:id" do
    let(:id) { order.id }

    example_request "Show a specific order" do
      expect(response_status).to eq(200)
      expect(response_body).to include(order.id.to_s)
    end
  end

  post "/api/v1/orders" do
    route_summary "Create a Order"
    route_description "Creates a order for user."

    example_request "Create a new order" do
      expect(response_status).to eq(200)
      expect(response_body).to have_json_path("data")
      expect(response_body).to be_json_eql("draft".to_json).at_path("data/attributes/status")
    end
  end

  put "/api/v1/orders/:id" do
    route_summary "Update a Order"
    route_description "Updates a order with new status."

    let(:id) { order.id }
    let(:type) { "orders" }
    let(:status) { "sent" }

    with_options scope: :data, with_example: true do
      parameter :type, "Resource type", required: true
    end
    with_options scope: [ :data, :attributes ], with_example: true do
      parameter :status, "New status for the order"
    end

    let(:raw_post) do
      params.to_json
    end

    example_request "Update an order's status" do
      expect(response_status).to eq(200)
      expect(response_body).to have_json_path("data")
      expect(response_body).to be_json_eql("sent".to_json).at_path("data/attributes/status")
    end
  end
end
