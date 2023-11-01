require 'rails_helper'

RSpec.describe "PUT Subscription", type: :request do
  describe 'Cancel Subscription' do
    describe 'Happy Path' do
      it 'cancels a subscription' do
        customer = create(:customer)
        tea = create(:tea)
        subscription = create(:subscription, customer_id: customer.id, tea_id: tea.id, status: 'active')
        
        put "/api/v0/subscriptions/#{subscription.id}"
        
        expect(response).to be_successful
        expect(response.status).to eq(200)
        
        canceled_sub = JSON.parse(response.body, symbolize_names: true)
        expect(canceled_sub).to be_a(Hash)
        expect(canceled_sub).to have_key(:data)
        expect(canceled_sub[:data]).to be_a(Hash)
        expect(canceled_sub[:data]).to have_key(:id)
        expect(canceled_sub[:data]).to have_key(:type)
        expect(canceled_sub[:data][:type]).to eq('subscription')
        
        expect(canceled_sub[:data]).to have_key(:attributes)
        expect(canceled_sub[:data][:attributes]).to be_a(Hash)
        expect(canceled_sub[:data][:attributes]).to have_key(:title)
        expect(canceled_sub[:data][:attributes]).to have_key(:price)
        
        expect(canceled_sub[:data][:attributes]).to have_key(:status)
        expect(canceled_sub[:data][:attributes][:status]).to be_a(String)
        expect(canceled_sub[:data][:attributes][:status]).to eq('inactive') # changed from active to inactive
        
        expect(canceled_sub[:data][:attributes]).to have_key(:frequency)
        expect(canceled_sub[:data][:attributes][:customer_id]).to eq(customer.id)
        expect(canceled_sub[:data][:attributes][:tea_id]).to eq(tea.id)
      end
    end

    describe 'Sad Path' do
      it 'returns an error if subscription is already inactive' do
        customer = create(:customer)
        tea = create(:tea)
        subscription = create(:subscription, customer_id: customer.id, tea_id: tea.id, status: 'inactive')
        
        put "/api/v0/subscriptions/#{subscription.id}"
        
        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        
        error = JSON.parse(response.body, symbolize_names: true)
     
        expect(error).to be_a(Hash)
        expect(error).to have_key(:error)
        expect(error[:error]).to eq('Subscription is already inactive')
      end
    end
  end
end