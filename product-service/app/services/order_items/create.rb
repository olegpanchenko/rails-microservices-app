module OrderItems
  class Create
    def self.call(attributes, relationships)
      new(attributes, relationships).call
    end

    def initialize(attributes, relationships)
      @attributes = attributes
      @relationships = relationships
      @order = Order.find(@relationships[:order][:data][:id])
    end

    def call
      product_id = @relationships[:order][:data][:id]

      order_item = @order.order_items.new(@attributes.merge(product_id: product_id))
      Products::UpdateInventory.call(product_id, -order_item.quantity)
      order_item.save!
    end
  end
end
