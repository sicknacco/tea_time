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

      sub = JSON.parse(response.body, symbolize_names: true)

      expect(sub).to be_a(Hash)
      expect(sub).to have_key(:data)
      expect(sub[:data]).to be_a(Hash)
      expect(sub[:data]).to have_key(:id)
      expect(sub[:data][:id]).to be_a(String)
      expect(sub[:data]).to have_key(:type)
      expect(sub[:data][:type]).to eq('subscription')

      expect(sub[:data]).to have_key(:attributes)
      expect(sub[:data][:attributes]).to be_a(Hash)
      expect(sub[:data][:attributes]).to have_key(:title)
      expect(sub[:data][:attributes][:title]).to be_a(String)
      expect(sub[:data][:attributes]).to have_key(:price)
      expect(sub[:data][:attributes][:price]).to be_a(String)
      expect(sub[:data][:attributes]).to have_key(:status)
      expect(sub[:data][:attributes][:status]).to be_a(String)
      expect(sub[:data][:attributes]).to have_key(:frequency)
      expect(sub[:data][:attributes][:frequency]).to be_a(String)

      expect(sub[:data][:attributes]).to have_key(:customer_id)
      expect(sub[:data][:attributes][:customer_id]).to be_a(Integer)
      expect(sub[:data][:attributes][:customer_id]).to eq(customer.id)
      expect(sub[:data][:attributes]).to have_key(:tea_id)
      expect(sub[:data][:attributes][:tea_id]).to be_a(Integer)
      expect(sub[:data][:attributes][:tea_id]).to eq(tea.id)
    end
  end

  describe 'Sad Path' do
    it 'returns an error if customer_id is missing' do
      tea = create(:tea)

      payload = {
        title: 'The Good One',
        price: 10.99,
        status: 'active',
        frequency: 'bi-monthly',
        customer_id: '',
        tea_id: tea.id
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/subscriptions', headers: headers, params: JSON.generate(payload)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)
   
      expect(error).to be_a(Hash)
      expect(error).to have_key(:error)
      expect(error[:error]).to eq("Customer must exist and Customer can't be blank")
    end

    it 'returns an error if tea_id is missing' do
      customer = create(:customer)

      payload = {
        title: 'The Good One',
        price: 10.99,
        status: 'active',
        frequency: 'bi-monthly',
        customer_id: customer.id,
        tea_id: ''
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/subscriptions', headers: headers, params: JSON.generate(payload)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a(Hash)
      expect(error).to have_key(:error)
      expect(error[:error]).to eq("Tea must exist and Tea can't be blank")
    end

    it 'returns an error if another attribute is missing' do
      customer = create(:customer)
      tea = create(:tea)

      payload = {
        title: 'The Good One',
        price: '',
        status: 'active',
        frequency: 'bi-monthly',
        customer_id: customer.id,
        tea_id: tea.id
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/subscriptions', headers: headers, params: JSON.generate(payload)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)
      
      expect(error).to be_a(Hash)
      expect(error).to have_key(:error)
      expect(error[:error]).to eq("Price can't be blank")
    end
  end

  describe 'Cancel Subscription' do
    it 'cancels a subscription' do
      customer = create(:customer)
      tea = create(:tea)
      subscription = create(:subscription, customer_id: customer.id, tea_id: tea.id, status: 'active')

      put "/api/v0/subscriptions/#{subscription.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      canceled_sub = JSON.parse(response.body, symbolize_names: true)
      expect(canceled_sub).to be_a(Hash)
    end
  end
end