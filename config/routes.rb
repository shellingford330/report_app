Rails.application.routes.draw do
  root   'students#login_form'

  get '/help' => 'top#help'

  get    '/students/login'      => 'students#login_form',    as: :login_form_students
  # post   '/students/login'
  # delete '/students/logout'
  # post   '/students/upgrade',                               as: :upgrade_student
  resources :students do
    collection do
      post :login
      delete :logout
      post :upgrade
    end
  end

  resources :student_activations, only: [:show, :edit]
  
  resources :groups, except: [:edit, :update]

  namespace :teachers do 
    resources :news, only: [:index, :show] do
      resources :students, only: [:show], controller: :news_students do
        resources :replies,  only: [:create], controller: :news_replies
      end
    end
  end
  
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

  resources :news, except: [:edit, :update] do
    collection do
      get :select
    end
    member do
      post :release, :file, :reply
    end
  end

  resources :contacts, except: [:edit, :update] do
    member do
      post :reply
    end
  end

  resources :messages, only: [:index, :new, :show, :create]

  resources :search, only: [:index]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
