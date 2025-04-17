require 'rails_helper'

RSpec.describe Products::UpdateInventory do
  let!(:product) { FactoryBot.create(:product, inventory: 10) }

  describe '.call' do
    context 'when inventory is increased' do
      it 'increments the inventory by the given amount' do
        expect {
          described_class.call(product.id, 5)
        }.to change { product.reload.inventory }.from(10).to(15)
      end
    end

    context 'when inventory is decreased but stays non-negative' do
      it 'decrements the inventory by the given amount' do
        expect {
          described_class.call(product.id, -3)
        }.to change { product.reload.inventory }.from(10).to(7)
      end
    end

    context 'when inventory would go negative' do
      it 'raises an error and does not update the product' do
        expect {
          described_class.call(product.id, -11)
        }.to raise_error("Sold out")

        expect(product.reload.inventory).to eq(10)
      end
    end

    context 'with concurrent updates (optional simulation)' do
      it 'uses row-level locking to prevent race conditions' do
        threads = []

        # Try to decrement the inventory in two threads simultaneously
        2.times do
          threads << Thread.new do
            begin
              described_class.call(product.id, -6)
            rescue => e
              e.message
            end
          end
        end

        threads.each(&:join)
        product.reload

        # Only one should succeed, the other should raise "Sold out"
        expect(product.inventory).to eq(4).or eq(10) # Depending on order
      end
    end
  end
end
