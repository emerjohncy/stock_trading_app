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
        get 'dashboard/users', to: "dashboard#index", as: :authenticated_root
        get 'dashboard/user/new', to: "dashboard#new"
        post 'dashboard/users', to: "dashboard#create", as: :create_new_user
        get 'dashboard/users/:id', to: "dashboard#show", as: :view_user
        get 'dashboard/users/:id/edit', to: "dashboard#edit", as: :edit_user
        patch 'dashboard/users/:id', to: "dashboard#update"
        put 'dashboard/users/:id', to: "dashboard#update"
        patch 'dashboard/users/:id/change', to: "dashboard#change_status", as: :change_status
      end
    end
  end

  root to: 'homepage#home'

  # Stocks Routes
  # resources :stocks, only: [:index, :show, :update]
  get '/stocks/:id' => 'stocks#show',
    as: 'stock'

  
  # Transaction Routes
  get '/transactions' => 'transactions#all_transactions',
    as: 'transactions'
  get '/user_transactions' => 'transactions#user_transactions',
    as: 'user_transactions'
  get '/users/:user_id/stocks/:id/transactions' => 'transactions#stock_transactions',
    as: 'stock_transactions'
  get '/users/:user_id/stocks/:id/transactions/buy' => 'transactions#buy',
    as: 'buy_stock'
  post '/users/:user_id/stocks/:id/transactions' => 'transactions#create'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
