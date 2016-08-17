Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/spotify', to: 'spotify#show'
  get '/spotify/authorize', to: 'spotify#authorize'
  get '/spotify/dashboard', to: 'spotify#dashboard'
  get '/spotify/validateauth', to: 'spotify#authorize_finish'

end
