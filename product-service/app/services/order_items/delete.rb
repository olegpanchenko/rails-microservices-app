module OrderItems
  class Delete
    def self.call(order_item)
      new(order_item).call
    end

    def initialize(order_item)
      @order_item = order_item
    end

    def call
      Products::UpdateInventory.call(@order_item.product_id, @order_item.quantity)
      @order_item.destroy
    end
  end
end
