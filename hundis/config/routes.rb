Rails.application.routes.draw do
  get 'Home', to: 'static_pages#Home'

  get 'Problems', to: 'static_pages#Problems'

  get 'User_Signin', to: 'static_pages#User_Signin'

  get 'Create_User', to: 'static_pages#Create_User'

  get 'User_Account', to: 'static_pages#User_Account'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'static_pages#Home'
  
end
