Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants#find'
      get '/items/find', to: 'items#find'

      resources :items, except: [:new, :edit]
      resources :merchants, only: [:index, :show]
      
      get '/merchants/:id/items', to: 'merchants/items#index'
      get '/items/:id/merchant', to: 'items/merchants#index'
    end
  end
end
