RailsjazzCom::Application.routes.draw do
  resource :user_session do 
    get 'logout'
  end
  resources :password_resets
  resources :users

  resources :places, :only => [:index, :show]

  namespace :admin do
    match '/', :to => 'dashboard#welcome'
    resources :locations do
      member do
        get :approve
      end
    end
    resources :comments do
      member do
        get :approve
      end
    end
    resources :users do
      member do
        get :toggle_admin
      end
    end
  end
  namespace :dashboard do
    match '/', :to => 'dashboard#welcome'
    resources :users, :only => [:edit, :update, :show] do
      resources :locations do
        resources :comments, :only => [:index, :destroy] do
          member do
            get :approve
          end
        end
      end
    end
  end
  
  resources :locations, :only => [] do
    resources :comments, :only => [:create]
  end
  
  root :controller => 'home', :action => 'index'
  match "/sitemap.xml" , :controller => "sitemap", :action => "sitemap", :format => 'xml' 
  match '/markers', :controller => 'home', :action => 'markers'
  match '/find_bar', :controller => 'home', :action => 'find_bar'
end