#
# def
#

Rails.application.routes.draw do

  get 'problems/index'

  id_cnstrt = /\d+/


  root  'static_pages#Home'
  get   '/Home',          to: redirect('/')


  # Authorization
  get   '/auth/login',    to: 'static_pages#login'
  post  '/auth/login',    to: 'sessions#create', as: 'login'
  get   '/auth/logout',   to: 'sessions#destroy', as: 'logout'
  get   '/auth/register', to: 'static_pages#register', as: 'register'
  post  '/auth/register', to: 'users#create'
  get   '/auth/failure',  to: redirect('/auth/login')
  get   '/auth/:provider/callback',  to: 'sessions#create'

  resources :sessions, only: [:create, :destroy]


  # Subsection Homepages
  get   '/problems',    to: 'static_pages#problems'
  get   '/users',       to: 'static_pages#users'
  get   '/tournaments', to: 'static_pages#tournaments'

  # Problems Subsection
  get   '/problems/statistics',         to: 'problems#stats'
  get   '/problems/:id',                to: 'problems#show',          id: id_cnstrt, as: :problem
  get   '/problems/:id/submit/',        to: 'problems#showUpload',    id: id_cnstrt
  post  '/problems/:id/submit/code',    to: 'problems#uploadCode',    id: id_cnstrt
  post  '/problems/:id/submit/output',  to: 'problems#uploadOutput',  id: id_cnstrt

  # Users Subsection
  get   '/users/:id',                 to: 'users#show',   id: id_cnstrt,  as: :user
  get   '/users/:username/(*all)',    to: redirect('/temp') # TODO: reprocess names to IDs
  get   '/users/:id/statistics',      to: 'users#stats',  id: id_cnstrt

  # Tournaments Subsection
  get   '/tournaments/:id',             to: 'tournaments#show',   id: id_cnstrt
  get   '/tournaments/:id/statistics',  to: 'tournaments#stats',  id: id_cnstrt

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


end
