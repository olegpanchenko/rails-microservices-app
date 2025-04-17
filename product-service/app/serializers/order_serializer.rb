class OrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :total

  belongs_to :user
end
