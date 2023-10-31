FactoryBot.define do
  factory :subscription do
    title { "MyString" }
    price { "MyString" }
    status { "MyString" }
    frequency { "MyString" }
    customer { nil }
    tea { nil }
  end
end
