Adela::Application.routes.draw do
  devise_for :users

  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    patch 'users/:id' => 'devise/registrations#update', :as => 'user_registration'
  end

  get "/:slug/catalogo" => "organizations#catalog", :as => "organization_catalog"
  resources :users, only: :show # FIXME Not being used
  root :to => "home#index"


  resources :organizations, only: :show do
    member do
      post "publish_catalog"
      get "publish_later"
    end
  end

  resources :inventories do
    collection do
      get "publish"
      get "ignore_invalid_and_save"
    end
  end

  resources :topics


  namespace :api, defaults: { format: 'json'} do
    namespace :v1 do

      get "/catalogs" => "organizations#catalogs"

      resources :organizations do
        collection do
          get "catalogs"
        end
      end
    end
  end
end
