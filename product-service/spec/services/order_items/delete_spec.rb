require 'rails_helper'

RSpec.describe OrderItems::Delete do
  let!(:product) { FactoryBot.create(:product, inventory: 10) }
  let!(:order) { FactoryBot.create(:order) }
  let!(:order_item) { FactoryBot.create(:order_item, product: product, quantity: 3) }

  describe '.call' do
    it 'decreases the product inventory by the order_item quantity' do
      expect {
        described_class.call(order_item)
      }.to change { product.reload.inventory }.from(10).to(13)
    end

    it 'destroys the order_item' do
      expect {
        described_class.call(order_item)
      }.to change { OrderItem.count }.by(-1)
    end
  end
end
