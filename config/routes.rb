Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "fixtures#index"

  resources :fixtures
  resources :picks
  resources :matchweeks do
    resources :fixtures
  	member do
  		post 'activate'
      post 'lock'
      post 'archive'
  	end
  end
end