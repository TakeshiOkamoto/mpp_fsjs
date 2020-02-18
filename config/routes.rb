Rails.application.routes.draw do

  root to: 'fsjs_main#index'
  resources :fsjs_capitals
  resources :fsjs_journals
  resources :fsjs_accounts
  
  get  '/login', to: 'fsjs_login#new'
  post '/login', to: 'fsjs_login#create'
  delete '/logout', to: 'fsjs_login#destroy'
  
end
