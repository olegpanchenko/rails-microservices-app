module OrderItems
  class Update
    def self.call(order_item, attributes)
      new(order_item, attributes).call
    end

    def initialize(order_item, attributes)
      @order_item = order_item
      @attributes = attributes
    end

    def call
      dff = @order_item.quantity - @attributes[:quantity]
      Products::UpdateInventory.call(@order_item.product_id, dff) unless dff.zero?

      @order_item.update(@attributes)
    end
  end
end
