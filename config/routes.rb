Rails.application.routes.draw do

  resources :contacts
  root   'teachers#index'

  get    '/students/login'      => 'students#login_form'
  post   '/students/login'
  delete '/students/logout'
  post   '/students/upgrade',                               as: :upgrade_student
  resources :students 
  
  get    '/teachers/login'      => 'teachers#login_form'
  post   '/teachers/login'
  delete '/teachers/logout'
  post   '/teachers/:id/auth'   => 'teachers#auth',         as: :auth_teacher
  resources :teachers

  post   '/reports/:id/release' => 'reports#release',       as: :release_report
  post   '/reports/:id/draft'   => 'reports#draft',         as: :draft_report
  get    '/reports/teacher'     => 'reports#teacher_index', as: :teacher_reports
  get    '/reports/student'     => 'reports#student_index', as: :student_reports
  resources :reports, except: :index

  post   '/news/:id/release' => 'news#release',       as: :release_news
  post   '/news/:id/draft'   => 'news#draft',         as: :draft_news
  get    '/news/select_students',                           as: :select_students_news
  resources :news

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
