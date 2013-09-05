Blitzgift::Application.routes.draw do
  match 'contactus' => 'contacts#new', :as => :contactus
end
