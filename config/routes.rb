Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
  
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  root to: 'mans#index'

  resources :users, only: [:show]

  resources :intros, only: [:new, :create, :edit, :update]
  
  resources :mans, only: [:new, :create, :show, :edit, :update, :destroy] do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
    collection do
      get 'search'
    end
  end

  resources :relationships, only: [:create, :destroy]

  resources :notifications, only: [:index, :destroy]

  get '/mans/category/:id', to: 'mans#category'

  get '/timeline/:id', to: 'mans#timeline'

  get '/mans/tag/:name', to: "mans#tag"

  get '/likes/user/:id', to: "likes#index"
end
