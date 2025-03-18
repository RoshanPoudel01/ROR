Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Namespace for API v1 routes
  namespace :api do
    namespace :v1 do
      resources :auth, only: [] do
        post :assign_roles, on: :collection
        post :login, on: :collection
        post :assign_permissions, on: :collection
      end
      resources :users
      resources :roles
      resources :permissions
      resources :artists do
        collection do
          get :export
          post :import
        end
      end
      resources :music do
        collection do
          get "show_by_artist/:artist_id", action: :show_by_artist
        end
      end
    end
  end
end
