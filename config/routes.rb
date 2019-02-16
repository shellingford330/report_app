Rails.application.routes.draw do

  root   'students#login_form'

  get    '/students/login' => 'students#login_form'
  post   '/students/login'
  delete '/students/logout'
  get    '/teachers/login' => 'teachers#login_form'
  post   '/teachers/login'
  delete '/teachers/logout'
  resources :students 
  resources :teachers

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
