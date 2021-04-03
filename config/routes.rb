Rails.application.routes.draw do
  devise_for :users
  root to: 'main#index'
  get 'main/index'

  resources :categories
  resources :discussions do
    resources :posts, module: :discussions

    collection do
      get "category/:id", to: "categories/discussions#index", as: :category
    end
  end
end
