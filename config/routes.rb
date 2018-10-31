Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "callbacks" }

  root to: "welcome#index"

  resources :dashboard
  get "new_gist", to: "dashboard#new_gist", as: "new_gist"
  post "create_gist", to: "dashboard#create_gist", as: "create_gist"
  get "get_gists/:login", to: "dashboard#get_gists", as: "get_gists"
  get "gist_content(/:gistid)", to: "dashboard#gist_content", as: "gist_content"
  put "star_gist(/:gistid)", to: "dashboard#star_gist", as: "star_gist"
  put "unstar_gist(/:gistid)", to: "dashboard#unstar_gist", as: "unstar_gist"
end
