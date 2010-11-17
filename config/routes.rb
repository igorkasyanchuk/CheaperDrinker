RailsjazzCom::Application.routes.draw do
  resource :user_session do 
    get 'logout'
  end
  resources :password_resets
  resources :users
  
  resources :cities, :only => [:index, :show]
  
  match '/autocomplete_location_name' => 'home#autocomplete_location_name'

  resources :places, :only => [:index, :show] do
    member {
      get :reviews
    }
  end

  namespace :admin do
    match '/', :to => 'dashboard#welcome'
    resources :locations do
      member {
        get :approve
      }
      resources :reviews, :only => [:index, :destroy] do
        member {
          get :approve
        }
      end
      resources :special_days do
        member {
          get :update_special
        }
      end
    end
    resources :reviews do
      member {
        get :approve
      }
    end
    resources :users do
      member {
        get :toggle_admin
      }
    end
  end
  namespace :dashboard do
    match '/', :to => 'dashboard#welcome'
    match '/add_bar', :to => 'dashboard#add_bar'
    match '/create_location', :to => 'dashboard#create_location'
    resources :users, :only => [:edit, :update, :show] do
      resources :locations do
        resources :special_days do
          member {
            get :update_special
          }
        end
        resources :reviews, :only => [:index, :destroy] do
          member {
            get :approve
          }
        end
      end
    end
  end
  
  resources :locations, :only => [] do
    resources :reviews, :only => [:create]
  end
  
  root :controller => 'home', :action => 'index'
  match "/sitemap.xml" , :controller => "sitemap", :action => "sitemap", :format => 'xml' 
  match '/markers', :controller => 'home', :action => 'markers'
  match '/find_bar', :controller => 'home', :action => 'find_bar'
end