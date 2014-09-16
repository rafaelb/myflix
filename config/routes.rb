Myflix::Application.routes.draw do

  root to: 'pages#index'

  get 'home', to: 'videos#index'

  get 'ui(/:action)', controller: 'ui'

  get 'register', to: 'users#new'
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'
  get 'people', to: 'relationships#index'
  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  get 'expired_token', to: 'password_resets#expired'
  get 'invite', to: 'invites#new'
  get 'refered_user', to: 'users#refer'

  resources :videos do
    resources :reviews, only: [:create]
    collection do
      post :search, to: 'videos#search'
    end
  end
  resources :categories
  resources :users, only: [:create, :show]
  resources :sessions, only: [:create]
  resources :queue_items, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:show, :create]
  resources :invites, only: [:create]
end
