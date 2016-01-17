Rails.application.routes.draw do

  resources :genres

  get "signin" => "sessions#new"

  resource :session

  get "signup" => "users#new"

  resources :users

  root "movies#index"

  # get "movies/filter/hits" => "movies#index", my_route_name: "hits"
  # get "movies/filter/flops" => "movies#index", my_route_name: "flops"
  
  get "movies/filter/:my_route_name" => "movies#index", as: :filtered_movies

  resources :movies do
    resources :reviews
  	resources :favorites
  end
end
