Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :ingredients do
    get :autocomplete, on: :collection, format: :json
  end

  resources :recipes do
    collection do 
      get :search, format: :json
    end
    
  end
  # Defines the root path route ("/")
  root "home#index"
end
