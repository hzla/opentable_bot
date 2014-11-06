Rails.application.routes.draw do

  
  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      namespace :fandango do
        resources :movies, only: [:index]
      end
      namespace :opentable do
      	get '/reserve', to: 'meals#reserve'
        get '/cancel', to: 'meals#cancel'
        get '/modify', to: 'meals#modify'
      end    
    end
  end


end
