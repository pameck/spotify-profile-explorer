Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/spotify', to: 'spotify#show'
  get '/spotify/login', to: 'spotify#login_user'
  get '/spotify/dashboard', to: 'spotify#dashboard'
  get '/spotify/auth', to: 'spotify#authorize_finish'

  root to: 'spotify#index'
end
