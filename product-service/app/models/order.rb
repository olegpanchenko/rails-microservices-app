class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  enum :status, { draft: 0, paid: 1, sent: 2, delivered: 3 }

  def user
    User.new(id: user_id)
  end

  def user=user
    self.user_id = user.id
  end
end
