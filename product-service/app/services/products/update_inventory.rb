module Products
  class UpdateInventory
    def self.call(product_id, dff)
      new(product_id, dff).call
    end

    def initialize(product_id, dff)
      @product_id = product_id
      @dff = dff
    end

    def call
      Product.transaction do
        product = Product.lock.find(@product_id) # SELECT FOR UPDATE
        new_inventory = product.inventory + @dff
        raise "Sold out" if new_inventory < 0
      
        product.update(inventory: new_inventory)
      end
    end
  end
end
