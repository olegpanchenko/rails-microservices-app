require 'faker'

52.times do
  Product.create(
    owner_id: (1..10).to_a.sample,
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    price: Faker::Commerce.price(range: 5..100.0).round(2),
    inventory: (1..10).to_a.sample
  )
end
