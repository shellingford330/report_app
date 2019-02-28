Rails.application.routes.draw do

  root   'teachers#index'

  get    '/students/login'      => 'students#login_form'
  post   '/students/login'
  delete '/students/logout'
  post   '/students/upgrade',                         as: :upgrade_student
  resources :students 
  
  get    '/teachers/login'      => 'teachers#login_form'
  post   '/teachers/login'
  delete '/teachers/logout'
  post   '/teachers/:id/auth'   => 'teachers#auth',   as: :auth_teacher
  resources :teachers

  post   '/reports/:id/release' => 'reports#release', as: :release_report
  post   '/reports/:id/draft'   => 'reports#draft',   as: :draft_report
  get    '/reports/teacher'     => 'reports#teacher_index', as: :teacher_reports
  get    '/reports/student'     => 'reports#student_index', as: :student_reports
  resources :reports, except: :index

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
