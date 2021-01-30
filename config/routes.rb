Rails.application.routes.draw do
  devise_for :users
  root to: 'mans#index'
end
