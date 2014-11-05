Rails.application.routes.draw do

  
  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      namespace :fandango do
        resources :movies
      end
      namespace :opentable do
      	get '/reserve', to: 'meals#reserve'
        get '/cancel', to: 'meals#cancel'
      end    
    end
  end


end
