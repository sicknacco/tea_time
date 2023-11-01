require 'rails_helper'

RSpec.describe "POST Subscription", type: :request do
  describe 'Get all subscriptions for a customer' do
    describe 'Happy Path' do
      it 'returns all subscriptions for a customer' do
        customer = create(:customer)
        tea1 = create(:tea)
        tea2 = create(:tea)
        tea3 = create(:tea)
        tea4 = create(:tea)

        sub1 = create(:subscription, customer_id: customer.id, tea_id: tea1.id, status: 'active')
        sub2 = create(:subscription, customer_id: customer.id, tea_id: tea2.id, status: 'active')
        sub3 = create(:subscription, customer_id: customer.id, tea_id: tea3.id, status: 'inactive')
        sub4 = create(:subscription, customer_id: customer.id, tea_id: tea4.id, status: 'inactive')

        get "/api/v0/customers/#{customer.id}/subscriptions"

        expect(response).to be_successful
        expect(response.status).to eq(200)

        subs = JSON.parse(response.body, symbolize_names: true)

        expect(subs).to be_a(Hash)
        expect(subs).to have_key(:data)
        expect(subs[:data]).to be_a(Array)
        subs[:data].each do |sub|
          expect(sub).to be_a(Hash)
          expect(sub).to have_key(:id)
          expect(sub[:id]).to be_a(String)
          expect(sub).to have_key(:type)
          expect(sub[:type]).to eq('subscription')
          expect(sub).to have_key(:attributes)

          expect(sub[:attributes]).to be_a(Hash)
          expect(sub[:attributes]).to have_key(:title)
          expect(sub[:attributes][:title]).to be_a(String)
          expect(sub[:attributes]).to have_key(:price)
          expect(sub[:attributes][:price]).to be_a(String)
          expect(sub[:attributes]).to have_key(:status)
          expect(sub[:attributes][:status]).to be_a(String)
          expect(sub[:attributes][:status]).to eq('active').or eq('inactive')
          expect(sub[:attributes]).to have_key(:frequency)
          expect(sub[:attributes][:frequency]).to be_a(String)
          expect(sub[:attributes]).to have_key(:customer_id)

          expect(sub[:attributes][:customer_id]).to be_a(Integer)
          expect(sub[:attributes][:customer_id]).to eq(customer.id)
          expect(sub[:attributes]).to have_key(:tea_id)
          expect(sub[:attributes][:tea_id]).to be_a(Integer)
          expect(sub[:attributes][:tea_id]).to eq(tea1.id).or eq(tea2.id).or eq(tea3.id).or eq(tea4.id)
        end
      end
    end

    describe 'Sad Path' do
      it 'returns an error if customer does not exist' do

        get '/api/v0/customers/000000/subscriptions'

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        
        error = JSON.parse(response.body, symbolize_names: true)

        expect(error).to be_a(Hash)
        expect(error).to have_key(:error)
        expect(error[:error]).to eq("Couldn't find Customer with 'id'=000000")
      end

      it 'returns an empty array if customer has no subscriptions' do
        customer = create(:customer)

        get "/api/v0/customers/#{customer.id}/subscriptions"

        expect(response).to be_successful
        expect(response.status).to eq(200)

        subs = JSON.parse(response.body, symbolize_names: true)
        
        expect(subs).to be_a(Hash)
        expect(subs).to have_key(:data)
        expect(subs[:data]).to be_a(Array)
        expect(subs[:data]).to eq([])
      end
    end
  end
end