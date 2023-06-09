require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }
  authenticate :user, lambda { |u| u.role? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  scope "/admin" do
    resources :users
  end

  devise_scope :user do
    # Redirests signing out users back to sign-in
    get "users", to: "devise/sessions#new"
  end

  post "/import_user/", to: "home#import_user"
  get "/toggle_admin/:id", controller: "users", action: "toggle_admin"
  get "/dashboard", controller: "home", action: "dashboard"
  get "/profile", controller: "home", action: "profile"
  get "/index", controller: "home", action: "index"
  root "home#index"
end
