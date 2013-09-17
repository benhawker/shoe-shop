ShoeShop::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: redirect('/pairs/top/all')

  resources :posts, path: "pairs" do
    member do
      post :callback
    end
    resources :watched_items, path: "watch", only: [:create, :destroy] 
    resources :comments, shallow: true
    resources :images, shallow: true
    member do 
      get :upvote
      get :downvote
    end
  end
  get 'pairs/:sort/:filter', to: 'filters#index', as: 'filters'
  get 'pairs/:sort/:filter/sold', to: 'filters#sold', as: 'sold_filters'
  post 'pairs/:sort/:filter', to: 'filters#toggle', as: 'toggle_filters'

  resources :users do
    resources :watched_items, path: "watching", only: [:index] 
  end
  get 'profile' => 'users#profile'
  get 'profile/watching' => 'watched_items#index'
    
  resource :sessions, only: [:new, :create, :destroy]

  scope '/admin' do
    resources :sizes
  end

  get 'sitemap', :to => 'pages#sitemap'
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'tos', to: 'pages#tos'
  get 'privacy_policy', to: 'pages#privacy_policy'
  get 'facebook', to: redirect("https://facebook.com/solesout")
  get 'twitter', to: redirect("https://twitter.com/solesout")
end
