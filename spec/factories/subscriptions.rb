FactoryBot.define do
  factory :subscription do
    title { Faker::Tea.variety }
    price { Faker::Number.between(from: 1, to: 20) }
    status { 'active' }
    frequency { 'monthly' }
    association :customer
    association :tea
  end
end
