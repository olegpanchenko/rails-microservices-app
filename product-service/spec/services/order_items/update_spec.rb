require 'rails_helper'

RSpec.describe OrderItems::Update do
  let!(:product) { FactoryBot.create(:product, inventory: 10) }
  let!(:order) { FactoryBot.create(:order) }
  let!(:order_item) { FactoryBot.create(:order_item, product: product, quantity: 5) }
  let(:attributes) { { quantity: 8 } }

  describe '.call' do
    context 'when quantity is increased' do
      it 'increases the product inventory' do
        expect {
          described_class.call(order_item, attributes)
        }.to change { product.reload.inventory }.from(10).to(7)
      end

      it 'updates the order_item quantity' do
        expect {
          described_class.call(order_item, attributes)
        }.to change { order_item.reload.quantity }.from(5).to(8)
      end
    end

    context 'when quantity is decreased' do
      let(:attributes) { { quantity: 3 } }

      it 'decreases the product inventory' do
        expect {
          described_class.call(order_item, attributes)
        }.to change { product.reload.inventory }.from(10).to(12)
      end

      it 'updates the order_item quantity' do
        expect {
          described_class.call(order_item, attributes)
        }.to change { order_item.reload.quantity }.from(5).to(3)
      end
    end

    context 'when quantity remains the same' do
      let(:attributes) { { quantity: 5 } }

      it 'does not update the inventory' do
        expect(Products::UpdateInventory).not_to receive(:call)

        described_class.call(order_item, attributes)

        expect(order_item.reload.quantity).to eq(5)
      end
    end

    context 'when inventory would go negative' do
      let(:attributes) { { quantity: 15 } }

      it 'raises an error and does not update the order_item' do
        allow(Products::UpdateInventory).to receive(:call).and_raise("Sold out")

        expect {
          described_class.call(order_item, attributes)
        }.to raise_error("Sold out")

        expect(order_item.reload.quantity).to eq(5)
      end
    end
  end
end
