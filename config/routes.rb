Rails.application.routes.draw do
  resources :memberships, only: [:new, :create, :destroy]
  resources :beer_clubs
  resources :users do
    post 'toggle_active', on: :member
  end

  resources :memberships do
    post 'toggle_active', on: :member
  end

  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end



  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :places, only: [:index, :show]
  resources :styles

  #search routes
  post 'places', to:'places#search'

  root 'breweries#index'

  get 'signup', to:'users#new'
  get 'signin', to:'sessions#new'
  delete 'signout', to:'sessions#destroy'
  get 'beerlist', to:'beers#list'
  get 'ngbeerlist', to:'beers#nglist'
  get 'ngbrewerylist', to:'breweries#nglist'
end
