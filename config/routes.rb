Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

  root to: "welcome#index"

  resources :dashboard
  get "show_gist/:id", to: "dashboard#show_gist", as: "show_gist"
end
