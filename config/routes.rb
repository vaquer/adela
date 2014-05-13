Adela::Application.routes.draw do
  devise_for :users

  match ":slug/catalogo" => "organizations#catalog", :as => "organization_catalog", via: :get
  resources :users, only: :show
  root :to => "home#index"

  resources :organizations, only: :show do
    member do
      post "publish_catalog"
    end
  end
  resources :inventories do
    collection do
      get "publish"
    end
  end

  namespace :api, defaults: { format: 'json'} do
    resources :organizations do
      collection do
        get "catalogs"
      end
    end
  end
end
