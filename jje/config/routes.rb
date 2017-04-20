#
# def
#
def user_translator(params)
  @user =
  @user ? @user.user_id : 0
end


Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  id_cnstrt = /\d+/


  root  'static_pages#Home'
  get   '/Home',          to: redirect('/')


  # Authorization
  get   '/auth/login',    to: 'static_pages#login'
  post  '/auth/login',    to: 'sessions#create',        as: 'login'
  get   '/auth/logout',   to: 'sessions#destroy',       as: 'logout'
  get   '/auth/register', to: 'static_pages#register',  as: 'register'
  post  '/auth/register', to: 'users#create',           as: :create_user
  get   '/auth/failure',  to: redirect('/auth/login')
  get   '/auth/:provider/callback',  to: 'sessions#create'

  resources :sessions, only: [:create, :destroy]


  # Subsection Homepages
  get   '/problems',    to: 'static_pages#problems',    as: :problems
  get   '/users',       to: 'static_pages#users',       as: :users
  get   '/tournaments', to: 'static_pages#tournaments', as: :tournaments

  # Problems Subsection
  get   '/problems/new',                to: 'problems#new',                           as: :new_problem
  post  '/problems',                    to: 'problems#create',                        as: :create_problem
  get   '/problems/statistics',         to: 'problems#stats',                         as: :stats_problem
  get   '/problems/:id',                to: 'problems#show',          id: id_cnstrt,  as: :problem
  get   '/problems/:id/submit/',        to: 'problems#showUpload',    id: id_cnstrt,  as: :upload_problem
  post  '/problems/:id/submit/code',    to: 'problems#uploadCode',    id: id_cnstrt,  as: :uploadCode_problem
  post  '/problems/:id/submit/output',  to: 'problems#uploadOutput',  id: id_cnstrt,  as: :uploadOutput_problem

  # Users Subsection
  get   '/users/:id',                   to: 'users#show',             id: id_cnstrt,  as: :user
  get   '/users/:id/edit',              to: 'users#edit',             id: id_cnstrt,  as: :edit_user
  put   '/users/:id',                   to: 'users#update',           id: id_cnstrt,  as: :update_user
  get   '/users/:id/submissions',       to: 'users#submissions',      id: id_cnstrt,  as: :submissions_user
  get   '/users/:username/(*all)',      to: 'users#name_to_id'

  # Tournaments Subsection
  get   '/tournaments/new',             to: 'tournaments#new',                        as: :new_tournament
  post  '/tournaments',                 to: 'tournaments#create',                     as: :create_tournament
  get   '/tournaments/:id',             to: 'tournaments#show',     id: id_cnstrt,    as: :tournament
  get   '/tournaments/:id/statistics',  to: 'tournaments#stats',    id: id_cnstrt,    as: :stats_tournament


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


end
