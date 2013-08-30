ShoeShop::Application.routes.draw do
  root to: 'posts#index'

  resources :posts, path: "pairs" do
    resources :watched_items, path: "watch", only: [:create, :destroy] 
    resources :comments, shallow: true
    resources :images, shallow: true
    member do 
      get :upvote
      get :downvote
    end
  end
  get 'pairs/:sort/:filter', to: 'filters#index', as: 'filters'
  
  resources :users do
    resources :watched_items, path: "watching", only: [:index] 
  end
  get 'profile' => 'users#profile'
  get 'profile/watching' => 'watched_items#index'
    
  resource :sessions, only: [:new, :create, :destroy]

  scope '/admin' do
    resources :sizes
  end

  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'tos', to: 'pages#tos'
  get 'privacy_policy', to: 'pages#privacy_policy'
end
