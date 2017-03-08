Rails.application.routes.draw do
  get '/Home',        to: redirect('/')

  get '/login',        to: 'static_pages#login'

  get '/register',     to: 'static_pages#register'

  # Subsection Homepages
  get '/problems',    to: 'static_pages#problems'
  get '/users',       to: 'static_pages#users'
  get '/tournaments', to: 'static_pages#tournaments'

  # Problems Subsection
  get '/problems/statistics', to: 'problems#stats'
  get '/problems/:id',        to: 'problems#show', constraints: { id: /\d+/ }
  get '/problems/:name',      to: 'problems#show'
  #get '/problems/submit',     to: '???'
  get '/problems/submit/:id/code',    to: 'problems#uploadCode', constraints: { id: /\d+/ }
  get '/problems/submit/:id/output',  to: 'problems#uploadOutput', constraints: { id: /\d+/ }
  
  # Users Subsection
  get '/users/current',             to: 'users#show'
  get '/users/current/statistics',  to: 'users#stats'
  get '/users/:id',                 to: 'users#show'
  get '/users/:id/statistics',      to: 'users#stats'
  
  # Tourtnaments Subsection
  get '/tournaments/:id',     to: 'tournaments#show', constraints: { id: /\d+/ }
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'static_pages#Home'
  
end
