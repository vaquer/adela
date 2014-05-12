Adela::Application.routes.draw do
  devise_for :users

  resources :users, only: :show
  resources :organizations, only: :show
  resources :inventories

  root :to => "home#index"
end
