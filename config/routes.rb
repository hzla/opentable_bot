Rails.application.routes.draw do

  
  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      namespace :fandango do
        resources :movies
      end
      namespace :opentable do
      	resources :meals
      end    
    end
  end


end
