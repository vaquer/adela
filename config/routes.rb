Adela::Application.routes.draw do

  root :to => "home#index"

  devise_for :users

  resources :users, only: :show
  resources :organizations, only: :show
  resources :inventories
end
