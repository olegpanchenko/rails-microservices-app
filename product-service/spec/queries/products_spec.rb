require 'rails_helper'

RSpec.describe Queries::Products do
  let(:owner_1) { 1 }
  let(:owner_2) { 2 }
  let(:time) { Time.now }
  let!(:product1) { FactoryBot.create(:product, name: 'Laptop', price: 500, owner_id: owner_1, updated_at: time) }
  let!(:product2) { FactoryBot.create(:product, name: 'Phone', price: 300, owner_id: owner_1, updated_at: time + 2.hours) }
  let!(:product3) { FactoryBot.create(:product, name: 'Tablet', price: 700, owner_id: owner_2, updated_at: time + 3.hours) }
  let!(:product4) { FactoryBot.create(:product, name: 'Headphones', price: 150, owner_id: owner_2, updated_at: time + 4.hours) }

  describe '#call' do
    context 'when filtering by owner' do
      it 'returns products for the specified owner_id' do
        query = Queries::Products.new(Product.all, owner_id: owner_1)
        products = query.call

        expect(products.count).to eq(2)
        expect(products.map(&:owner_id)).to all(eq(owner_1))
      end

      it 'returns no products when no matching owner_id' do
        query = Queries::Products.new(Product.all, owner_id: 999)
        products = query.call

        expect(products.count).to eq(0)
      end
    end

    context 'when filtering by name' do
      it 'returns products whose names match the given string' do
        query = Queries::Products.new(Product.all, name: 'Laptop')
        products = query.call

        expect(products.count).to eq(1)
        expect(products.first.name).to eq('Laptop')
      end

      it 'returns products that match part of the name' do
        query = Queries::Products.new(Product.all, name: 'Lap')
        products = query.call

        expect(products.count).to eq(1)
        expect(products.first.name).to eq('Laptop')
      end
    end

    context 'when filtering by price' do
      it 'returns products with price greater than or equal to the specified price_min' do
        query = Queries::Products.new(Product.all, price_min: 500)
        products = query.call

        expect(products.count).to eq(2)
        expect(products.pluck(:price)).to all(be >= 500)
      end

      it 'returns products with price less than or equal to the specified price_max' do
        query = Queries::Products.new(Product.all, price_max: 300)
        products = query.call

        expect(products.count).to eq(2)
        expect(products.pluck(:price)).to all(be <= 300)
      end

      it 'returns products within a price range' do
        query = Queries::Products.new(Product.all, price_min: 300, price_max: 600)
        products = query.call

        expect(products.count).to eq(2)
        expect(products.pluck(:price)).to all(be >= 300)
        expect(products.pluck(:price)).to all(be <= 600)
      end
    end

    context 'when sorting by created_at' do
      it 'returns products sorted by created_at in descending order' do
        query = Queries::Products.new(Product.all, sort: 'updated_at')
        products = query.call

        expect(products.last.updated_at).to be >= products.first.updated_at
      end
    end

    context 'when sorting by updated_at' do
      it 'returns products sorted by updated_at in descending order' do
        query = Queries::Products.new(Product.all, sort: '-updated_at')
        products = query.call

        expect(products.first.updated_at).to be >= products.last.updated_at
      end
    end

    context 'when paginating' do
      it 'returns the specified page of products' do
        query = Queries::Products.new(Product.all, page: 1, per_page: 2)
        products = query.call

        expect(products.count).to eq(2)
        expect(products.first).to eq(product4)
      end

      it 'returns the correct number of products per page' do
        query = Queries::Products.new(Product.all, page: 2, per_page: 2)
        products = query.call

        expect(products.count).to eq(2)
        expect(products.last).to eq(product1)
      end
    end
  end
end
