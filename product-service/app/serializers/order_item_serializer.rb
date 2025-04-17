class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :price

  belongs_to :order
  belongs_to :product
end
