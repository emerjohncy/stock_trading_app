Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'dashboard#home'
  get '/admin', to: 'dashboard#admin_dashboard'
  get '/trader', to: 'dashboard#trader_dashboard'

end
