class User
  include ActiveModel::Model
  attr_accessor :id, :email

  def read_attribute_for_serialization(attr)
    try attr
  end

  def persisted?
    false
  end

  def orders
    Order.where(user_id: self.id)
  end
end
