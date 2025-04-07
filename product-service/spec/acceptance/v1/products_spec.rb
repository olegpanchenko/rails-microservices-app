require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'support/shared_contexts/api/parameters'
require 'support/shared_contexts/api/response_fields'
require 'support/shared_contexts/api/errors'

resource 'Products' do
  explanation "Products resource"

  header "Content-Type", "application/json"
  authentication :apiKey, :authorization_token, name: 'Authorization', description: 'Authorization header JWT Token'

  before do
    allow(AuthService::GetUser).to receive(:new).and_return(double(call: user))
  end
  let(:email) { "user@example.com" }
  let(:user) { User.new(id: 1, email: email) }

  get "/api/v1/products" do
    route_summary "List Products"
    route_description "Retrieve a list of products."

    let!(:products) { FactoryBot.create_list(:product, 3) }

    context "when the Authorization token is not present" do
      example_request "Successfully retrieved list of products" do
        expect(response_status).to eq(200)
        expect(response_body).to have_json_path("data")
        expect(response_body).to be_json_eql(products.last.id.to_s.to_json).at_path("data/0/id")
        expect(response_body).to be_json_eql(products.last.name.to_s.to_json).at_path("data/0/attributes/name")
      end
    end

    context "when the Authorization token is valid" do
      let(:authorization_token) { 'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZW1haWwiOiJ1c2VyQGV4YW1wbGUuY29tIn0.ffW65kPR2X97StY7LNmSgliEkMBnwB2NYgw-9gMtb1Q' }

      context "when products exist" do
        # Response Fields
        response_field :data, 'Data', type: :array, items: {
          type: :object,
          title: 'Products Data',
          properties: {
            id: { type: :string, description: 'Product ID' },
            type: { type: :string, description: 'Resource type (e.g., products)' },
            attributes: {
              type: :object,
              description: 'Product attributes',
              properties: {
                name: { type: :string, description: 'Product name' },
                description: { type: :string, description: 'Product description' },
                price: { type: :number, description: 'Product price' }
              }
            }
          }
        }

        example_request "Successfully retrieved list of products" do
          expect(response_status).to eq(200)
          expect(response_body).to have_json_path("data")
          expect(response_body).to be_json_eql(products.last.id.to_s.to_json).at_path("data/0/id")
          expect(response_body).to be_json_eql(products.last.name.to_s.to_json).at_path("data/0/attributes/name")
        end
      end

      context "when no products exist" do
        let(:products) { [] }

        let(:data) {
          []
        }

        example_request "No products found" do
          expect(response_status).to eq(200)
          expect(response_body).to have_json_path("data")
          expect(response_body).to be_json_eql(data.to_json).at_path("data")
        end
      end
    end
  end

  get "/api/v1/products/:id" do
    route_summary "Get Product Details"
    route_description "Retrieve details of a product by ID."

    let(:id) { product.id }
    let(:product) { FactoryBot.create(:product) }

    context "when the Authorization token is invalid" do
      # Response Fields
      example_request "Successfully retrieved product" do
        expect(response_status).to eq(200)
      end
    end

    context "when the Authorization token is valid" do
      let(:authorization_token) { 'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZW1haWwiOiJ1c2VyQGV4YW1wbGUuY29tIn0.ffW65kPR2X97StY7LNmSgliEkMBnwB2NYgw-9gMtb1Q' }

      context "to a non-existing product" do
        # Response Fields
        include_context "errors response field"

        let(:id) { 2 }
        let(:errors_json) { { title: "Record not found", code: 404, status: 404 }.to_json }

        example_request "Product not found" do
          expect(response_status).to eq(404)
          expect(response_body).to be_json_eql(errors_json).at_path("errors/0")
        end
      end

      context "to an existing product" do
        # Response Fields
        include_context "data link response fields"

        with_options scope: [ :data, :attributes ] do
          response_field :name, "Name", type: :string
          response_field :description, "Description", type: :string
          response_field :price, "Price", type: :number
        end

        example_request "Successfully retrieved product details" do
          expect(response_status).to eq(200)
          expect(response_body).to have_json_path("data/id")
          expect(response_body).to have_json_path("data/attributes/name")
          expect(response_body).to be_json_eql(product.id.to_s.to_json).at_path("data/id")
          expect(response_body).to be_json_eql(product.name.to_json).at_path("data/attributes/name")
        end
      end
    end
  end
end
