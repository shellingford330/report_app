Rails.application.routes.draw do

  resources :reports
  root   'teachers#index'

  post   '/students/upgrade'
  get    '/students/login' => 'students#login_form'
  post   '/students/login'
  delete '/students/logout'
  resources :students 
  
  post   '/teachers/:id/auth' => 'teachers#auth'
  get    '/teachers/login' => 'teachers#login_form'
  post   '/teachers/login'
  delete '/teachers/logout'
  resources :teachers

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
