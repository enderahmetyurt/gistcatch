Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "callbacks" }

  root to: "welcome#index"

  resources :dashboard
  get "get_follower_gists/:login", to: "dashboard#get_follower_gists", as: "get_follower_gists"
  get 'gist_content(/:gistid)', to: "dashboard#gist_content", as: "gist_content"
end
