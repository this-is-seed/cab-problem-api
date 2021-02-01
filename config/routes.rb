Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :customers, only: [:create, :index]
      resources :drivers, only: [:create, :index]
      resources :rides, only: [:create, :index]

      put "customers" => "customers#update"
      put "drivers" => "drivers#update"
      put "rides" => "rides#update"
      put "rate_driver" => "rides#rate_driver"
    end
  end
end
