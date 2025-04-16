require 'rails_helper'

RSpec.describe OrderItems::Create do
  let(:owner_id) { 1 }
  let(:inventory) { 5 }

  let!(:product) { FactoryBot.create(:product, name: 'Laptop', inventory: inventory, price: 500, owner_id: owner_id) }
  let(:order) { FactoryBot.create(:order) }

  describe '#call' do
    let(:params) {
      {
        data: {
          type: "order_items",
          attributes: {
            quantity: 1
          },
          relationships: {
            order: {
              data: {
                id: order.id,
                type: "orders"
              }
            },
            product: {
              data: {
                id: product.id,
                type: "products"
              }
            }
          }
        }
      }
    }

    it 'creates order_items' do
      order_item = OrderItems::Create.call(params[:data][:attributes], params[:data][:relationships])
      expect(order_item).to be_present
      product.reload
      expect(product.inventory).to eq(inventory - 1)
    end

    it "prevents overbooking under concurrent access" do
      errors = []
      threads = []

      (inventory+1).times do
        threads << Thread.new do
          begin
            order_item = OrderItems::Create.call(params[:data][:attributes], params[:data][:relationships])
          rescue => e
            errors << e.message
          end
        end
      end

      threads.each(&:join)
      product.reload

      expect(OrderItem.count).to eq(inventory)
      expect(product.inventory).to eq(0)
      expect(errors.size).to eq(1)
      expect(errors.first).to eq("Sold out")
    end
  end
end
