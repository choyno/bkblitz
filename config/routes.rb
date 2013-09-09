Blitzgift::Application.routes.draw do
  resources :contacts
  match 'contactus' => 'contacts#new', :as => :contactus
  
  root to: 'users#show'

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', registration: 'users' } do
    get '/register', controller: 'devise/registrations', action: :new, as: :new_user_registration
  end

  get '/myaccount', controller: :users, action: :show

end
