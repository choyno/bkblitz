Blitzgift::Application.routes.draw do
  resources :contacts
  match 'contactus' => 'contacts#new', :as => :contactus

  root :to => 'contacts#index'
end
