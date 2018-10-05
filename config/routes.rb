Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

  root to: "welcome#index"
  resources :dashboard
end
