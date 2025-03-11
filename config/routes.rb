Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Namespace for API v1 routes
  namespace :api do
    namespace :v1 do
      resources :auth, only: [] do
        post :login, on: :collection
      end
      resources :users
      resources :artists
    end
  end
end
