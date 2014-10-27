Rails.application.routes.draw do

  
  namespace :api,:defaults => {:format => :json} do
    namespace :v1 do
      
      namespace :fandango do
        resources :movies
      end    

    end
  end


end
