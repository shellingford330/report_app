Rails.application.routes.draw do
  resources :teachers
  root 'students#login_form'
  get  '/students/login' => 'students#login_form'
  post '/students/login'
  delete '/students/logout'
  resources :students 

  get '/login' => 'login#new'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
