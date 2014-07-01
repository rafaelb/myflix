Myflix::Application.routes.draw do

  root to: 'pages#index'

  get 'home', to: 'videos#index'

  get 'ui(/:action)', controller: 'ui'

  get 'register', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  resources :videos do
    resources :reviews, only: [:create]
    collection do
      post :search, to: 'videos#search'
    end
  end
  resources :categories
  resources :users, only: [:create, :show]
  resources :sessions, only: [:create]


end
