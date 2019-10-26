Rails.application.routes.draw do
  root   'students#login_form'

  get    '/students/login'      => 'students#login_form'
  post   '/students/login'
  delete '/students/logout'
  post   '/students/upgrade',                               as: :upgrade_student
  get    '/students/:id/editbyteacher' => "students#editbyteacher",   as: :edit_by_teacher_student
  patch  '/students/:id/editbyteacher' => "students#updatebyteacher", as: :update_by_teacher_student
  resources :students 

  resources :student_activations, only: [:show, :edit]
  
  resources :groups
  
  resources :teachers do
    collection do
      get :login_form
      post :login
      delete :logout
    end
    member do
      post :auth
    end
  end

  resources :teacher_activations, only: [:show, :edit]

  
  resources :reports, except: :index do
    member do
      post :reply, :release, :draft
      get :teacher, :student
    end
  end

  resources :password_resets, only: [:edit, :create, :update]

  resources :multi_reports, only: [:index, :new, :create] do
    collection do
      post :edit
    end
  end

  resources :edit_reports, only: [:index, :new, :create]

  resources :news, except: :index do
    collection do
      get :select
    end
    member do
      post :release, :draft
      get :teacher, :student
    end
  end

  resources :contacts do
    member do
      post :reply
    end
  end

  resources :messages, only: [:index, :new, :show, :create]

  resources :search, only: [:index]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
