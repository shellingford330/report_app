Rails.application.routes.draw do
  resources :students 
  get '/login' => 'login#new'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
