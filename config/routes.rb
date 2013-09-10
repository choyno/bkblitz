Blitzgift::Application.routes.draw do
  root to: 'contacts#index'

  resources :contacts
  match 'contactus' => 'contacts#new', :as => :contactus

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', registration: 'users' } 
  devise_scope :user do
    get '/register', controller: 'devise/registrations', action: :new, as: :new_user_registration
  end

  get '/myaccount', controller: :users, action: :show
end
