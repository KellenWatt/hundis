Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :user_submissions
  resources :competes_ins
  resources :contains
  resources :tournament_languages
  resources :tournaments
  resources :problem_tags
  resources :problem_keywords
  resources :problems
  resources :users

  get 'static_pages/Home'

  get 'static_pages/Problems'

  get 'static_pages/User_Signin'

  get 'static_pages/Create_User'

  get 'static_pages/User_Account'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'static_pages#Home'
  
end
