Rails.application.routes.draw do
  
  devise_for :users, controllers: { registrations: "registrations" }
  scope "/admin" do
    resources :users
  end

  devise_scope :user do
    # Redirests signing out users back to sign-in
    get "users", to: "devise/sessions#new"
  end

  get "/dashboard", controller: "home", action: "dashboard"
  get "/profile", controller: "home", action: "profile"
  get "/index", controller: "home", action: "index"
  root "home#index"
end
