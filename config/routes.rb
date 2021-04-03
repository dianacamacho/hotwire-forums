Rails.application.routes.draw do
  resources :categories
  devise_for :users
  root to: 'main#index'
  get 'main/index'

  resources :discussions do
    resources :posts, module: :discussions
  end
end
