Rails.application.routes.draw do
  resources :memberships, only: [:new, :create, :destroy]
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :places, only: [:index, :show]

  #search routes
  post 'places', to:'places#search'

  root 'breweries#index'

  get 'signup', to:'users#new'
  get 'signin', to:'sessions#new'
  delete 'signout', to:'sessions#destroy'

end
