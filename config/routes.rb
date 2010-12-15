RailsjazzCom::Application.routes.draw do

  resource :user_session do 
    get 'logout'
  end

  resources :password_resets
  resources :users
  
  resources :contacts, :only => [:new, :create, :index]
  
  resources :states, :only => [:index, :show] do
    resources :cities, :only => [:index, :show] do
      member { get :map }
      resources :neighborhoods, :only => [:index, :show]
    end
  end
  
  match '/autocomplete_location_name' => 'home#autocomplete_location_name'
  match '/autocomplete_city_name' => 'home#autocomplete_city_name'
  match '/search' => 'home#search'
  match '/verify' => 'home#verify'
  match '/check_verify' => 'home#check_verify'

  resources :places, :only => [:index, :show] do
    member {
      get :reviews
      get :add_to_favorites
      get :remove_from_favorites
      get :events
    }
  end
  
  resources :events, :only => [:index, :show]

  namespace :admin do
    match '/', :to => 'dashboard#welcome'
    resources :contacts, :only => [:index, :destroy]
    resources :event_categories
    resources :events do
      member {  get :approve  }
    end
    resources :cities, :only => [:index, :show, :destroy] do
      member {  get :toggle  }
      resources :neighborhoods
    end
    resources :locations do
      member {  get :approve  }
      resources :reviews, :only => [:index, :destroy] do
        member {  get :approve  }
      end
      resources :special_days do
        member {  get :update_special  }
      end
    end
    resources :reviews do
      member {  get :approve  }
    end
    resources :users do
      member {  get :toggle_admin  }
    end
  end
  namespace :dashboard do
    match '/', :to => 'dashboard#welcome'
    match '/add_bar', :to => 'dashboard#add_bar'
    match '/create_location', :to => 'dashboard#create_location'
    resources :users, :only => [:edit, :update, :show] do
      resources :events
      resources :locations do
        resources :special_days do
          member {  get :update_special  }
        end
        resources :reviews, :only => [:index, :destroy] do
          member {  get :approve  }
        end
      end
    end
  end
  
  resources :locations, :only => [] do
    resources :reviews, :only => [:create]
  end
  
  root :controller => 'home', :action => 'index'
  match "/thisissitmemap.xml" , :controller => "sitemap", :action => "sitemap", :format => 'xml' 
  match '/markers', :controller => 'home', :action => 'markers'
  match '/find_bar', :controller => 'home', :action => 'find_bar'
end