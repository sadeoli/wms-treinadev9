Rails.application.routes.draw do
  devise_for :users
  authenticate :user do
    root to: 'home#index'
    resources :warehouses, only: [:show, :new, :create, :edit, :update, :destroy]
    resources :suppliers, only: [:index, :show, :new, :create, :edit, :update]
    resources :product_models, only: [:index, :show, :new, :create, :edit, :update]
    resources :orders, only: [:new, :create, :show, :index] do
      get 'search', on: :collection
    end
  end
end
