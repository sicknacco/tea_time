require 'factory_bot_rails'

Customer.destroy_all
Tea.destroy_all
Subscription.destroy_all

10.times do
  FactoryBot.create(:customer)
end

10.times do
  FactoryBot.create(:tea)
end

10.times do
  FactoryBot.create(:subscription)
end
