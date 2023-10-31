require 'rails_helper'

RSpec.describe "POST Subscription", type: :request do
  describe 'Happy Path' do
    it 'creates a subscription' do
      customer = create(:customer)
      tea = create(:tea)

      payload = {
        title: 'The Good One',
        price: 10.99,
        status: 'active',
        frequency: 'bi-monthly',
        customer_id: customer.id,
        tea_id: tea.id
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/subscriptions', headers: headers, params: JSON.generate(payload)

      expect(response).to be_successful
      expect(response.status).to eq(201)

      subscription = JSON.parse(response.body, symbolize_names: true)

      expect(subscription).to be_a(Hash)
    end
  end
end