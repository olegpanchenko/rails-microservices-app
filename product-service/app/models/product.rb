class Product < ApplicationRecord
  def owner
    User.new(id: owner_id)
  end
end
