Rails.application.routes.draw do

  root   'teachers#index'

  get    '/students/login'      => 'students#login_form'
  post   '/students/login'
  delete '/students/logout'
  post   '/students/upgrade',                               as: :upgrade_student
  get    '/students/:id/editbyteacher' => "students#editbyteacher",   as: :edit_by_teacher_student
  patch  '/students/:id/editbyteacher' => "students#updatebyteacher", as: :update_by_teacher_student
  resources :students 
  
  get    '/teachers/login'      => 'teachers#login_form'
  post   '/teachers/login'
  delete '/teachers/logout'
  post   '/teachers/:id/auth'   => 'teachers#auth',         as: :auth_teacher
  resources :teachers

  post   '/reports/:id/replies' => 'reports#reply',         as: :reply_report
  post   '/reports/:id/release' => 'reports#release',       as: :release_report
  post   '/reports/:id/draft'   => 'reports#draft',         as: :draft_report
  get    '/reports/:id/teacher'     => 'reports#teacher_index', as: :teacher_reports
  get    '/reports/:id/student'     => 'reports#student_index', as: :student_reports
  resources :reports, except: :index

  post   '/multi_reports/new_mix', as: :edit_multi_report
  resources :multi_reports, only: [:index, :new, :create]

  resources :edit_reports, only: [:index, :new, :create]

  get    '/news/select_students' => 'news#select' ,         as: :select_students 
  post   '/news/:id/release'     => 'news#release',         as: :release_news
  post   '/news/:id/draft'       => 'news#draft',           as: :draft_news
  get    '/news/:id/teacher'     => 'news#teacher_index',   as: :teacher_news
  get    '/news/:id/student'     => 'news#student_index',   as: :student_news
  resources :news, except: :index

  post   '/contacts/:id/replies' => 'contacts#reply',       as: :reply_contact
  resources :contacts

  resources :messages, only: [:index, :new, :show, :create]

  resources :search, only: [:index]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
