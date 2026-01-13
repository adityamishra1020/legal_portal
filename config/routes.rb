Rails.application.routes.draw do
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root "home#index"

  # Authentication routes
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout
  get "signup", to: "registrations#new", as: :signup
  post "signup", to: "registrations#create"

  # User profile routes
  resources :users, only: [:show, :edit, :update]

  # Admin routes (namespace structure)
  namespace :admin do
    get '/', to: 'admin#index', as: :dashboard
    get 'complaints', to: 'complaints#index', as: :complaints
    patch 'complaints/:id/status', to: 'complaints#update_status', as: :update_complaint_status
    get 'users', to: 'users#index', as: :users
    patch 'users/:id/role', to: 'users#update_role', as: :update_user_role
    patch 'users/:id/status', to: 'users#toggle_status', as: :toggle_user_status
    get 'analytics', to: 'admin#analytics', as: :analytics
  end

  # Complaints resources
  resources :complaints, only: [:new, :create, :show, :edit, :update] do
    collection do
      get 'my_complaints', to: 'complaints#my_complaints', as: :my_complaints
    end
  end

  # Lawyers resources
  resources :lawyers, only: [:index, :show] do
    collection do
      get 'register', to: 'lawyers#new', as: :registration
    end
  end
end
