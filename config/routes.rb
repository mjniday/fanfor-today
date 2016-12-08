Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root to: "fixtures#index"

  root to: "leagues#index"

  resources :leagues do
    member do
      post 'invite_user'
    end
  end

  resources :picks
  resources :matchweeks do
    resources :fixtures
  	member do
  		post 'activate'
      post 'archive'
      post 'populate_matchweek_fixtures'
  	end
  end
end