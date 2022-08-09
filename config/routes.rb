Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
    registrations: 'admins/registrations'
  }

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    authenticated :user do
      namespace :users do
        get 'dashboard/index', as: :authenticated_root
      end
    end
  end

  devise_scope :admin do
    authenticated :admin do
      namespace :admins do
        get 'dashboard/index', as: :authenticated_root
        get 'dashboard/user/new', to: "dashboard#new"
        post 'dashboard/users', to: "dashboard#create", as: :create_new_user
      end
    end
  end

  root to: 'homepage#home'

  # Stocks Routes
  # resources :stocks, only: [:index, :show, :update]

  get '/stocks' => 'stocks#index',
    as: 'stocks'
  
  get '/stocks/:id' => 'stocks#show',
    as: 'stock'

  patch '/stocks/:id' => 'stocks#update',
    as: 'update_stock'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
