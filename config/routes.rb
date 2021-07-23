Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants/search#find'
      get '/items/find_all', to: 'items/search#find_all'

      resources :items, except: [:new, :edit]
      resources :merchants, only: [:index, :show]
      
      get '/merchants/:id/items', to: 'merchants/items#index'
      get '/items/:id/merchant', to: 'items/merchants#index'

      get '/revenue/items', to: 'revenue/items#index'
      get '/revenue/weekly', to: 'revenue#index'
      get '/revenue', to: 'revenue#show'
    end
  end
end
