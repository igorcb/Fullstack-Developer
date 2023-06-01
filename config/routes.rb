Rails.application.routes.draw do
  devise_scope :user do
    # Redirests signing out users back to sign-in
    get "users", to: "devise/sessions#new"
  end
  
  devise_for :users
  
  get "/dashboard", controller: "home", action: "dashboard"
  get "/profile", controller: "home", action: "profile"
  get "/index", controller: "home", action: "index"
  root "home#index"
end
