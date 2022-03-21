FactoryBot.define do
  factory :book do
    name { Faker::Book.title }
    stock { rand(10..20) }
    price { rand(10..100) }
  end
end