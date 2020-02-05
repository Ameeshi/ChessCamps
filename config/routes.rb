Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search
  root 'home#index'

  # Authentication routes
  resources :sessions
  resources :users
  get 'signup', to: 'families#new', as: :signup
  get 'user/edit', to: 'users#edit', as: :edit_current_user
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  # Routes for main resources
  resources :camps
  resources :instructors
  resources :locations
  resources :curriculums
  resources :families 
  resources :students 
  resources :registrations

  # Routes for managing camp instructors
  get 'camps/:id/instructors', to: 'camps#instructors', as: :camp_instructors
  post 'camps/:id/instructors', to: 'camp_instructors#create', as: :create_instructor
  delete 'camps/:id/instructors/:instructor_id', to: 'camp_instructors#destroy', as: :remove_instructor

  # Routes for managing registrations
  get 'camps/:id/students', to: 'camps#students', as: :camp_students
  post 'camps/:id/students', to: 'registrations#create', as: :create_student
  delete 'camps/:id/students/:student_id', to: 'registrations#destroy', as: :remove_student

  # Routes for carts 
  get "carts/add_to_cart/:id" => "carts#add_to_cart", as: :add_to_cart
  get "view_cart" => "home#view_cart", as: :view_cart
  get "carts/new" => "carts#new", as: :new_cart
  post "carts/create" => "carts#create", as: :create_cart
  post "carts/delete_from_cart/:camp_id/:student_id" => "carts#delete_from_cart", as: :delete_from_cart

end








