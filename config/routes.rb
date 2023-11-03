Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :subscriptions, only: [:create, :update]
      get 'customers/:customer_id/subscriptions', to: 'customers_subscriptions#index'
    end
  end
end
