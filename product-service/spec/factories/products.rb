FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    price { Faker::Commerce.price }
    owner_id { Faker::Number.number(digits: 2) }
  end
end
