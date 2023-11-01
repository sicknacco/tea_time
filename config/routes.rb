Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :subscriptions, only: [:create, :update]
    end
  end
end
