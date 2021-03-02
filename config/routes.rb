Rails.application.routes.draw do
  devise_for :users
  root to: 'main#index'
  get 'main/index'

  resources :discussions, only: [:index]
end
