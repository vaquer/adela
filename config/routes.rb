Adela::Application.routes.draw do
  localized do
    devise_for :users

    as :user do
      get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
      patch 'users/:id' => 'devise/registrations#update', :as => 'user_registration'
    end

    get "/:slug/catalogo" => "organizations#catalog", :as => "organization_catalog"
    get "/:slug/plan" => "organizations#opening_plan"

    get "/maqueta/" => "home#maqueta"
    post "/maqueta/" => "home#maqueta"
    root :to => "home#index"

    resources :organizations, only: [:show, :update] do
      post "publish_catalog", :on => :member
      get "publish_later", :on => :member
      get "profile", :on => :member
      get "search", :on => :collection
    end

    resources :catalogs do
      collection do
        get "publish"
      end
    end

    resources :inventories, only: [:index, :new, :create, :show, :update] do
      member do
        get 'publish'
      end
    end

    resources :opening_plan, only: [:index, :new, :create] do
      member do
        get 'organization'
        get 'export'
      end
    end
  end

  namespace :api, defaults: { format: 'json'} do
    namespace :v1 do
      get "/catalogs" => "organizations#catalogs"
      get "/organizations" => "organizations#organizations"
      get "/gov_types" => "organizations#gov_types"

      resources :organizations do
        collection do
          get "catalogs"
          get "organizations"
        end
      end
    end
  end

  namespace :admin do
    get '/', to: 'base#index', as: 'root'

    get 'import_users', to: 'users#import'
    post 'create_users', to: 'users#create_users'
    post 'stop_acting', to: 'users#stop_acting'
    resources :users, except: :show do
      member do
        put 'grant_admin_role'
        put 'remove_admin_role'
        get 'acting_as'
        get 'edit_password'
        put 'update_password'
      end
    end

    resources :organizations, except: [:show, :destroy]
  end
end
