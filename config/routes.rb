RailsjazzCom::Application.routes.draw do
  resource :user_session do 
    get 'logout'
  end
  resources :password_resets
  resources :users
  
  namespace :admin do
    match '/', :to => 'dashboard#welcome'
    resources :users do
      member do
        get :toggle_admin
      end
    end
  end
  namespace :dashboard do
    match '/', :to => 'dashboard#welcome'
    resources :users, :only => [:edit, :update, :show] do
      resources :locations
    end
  end
  
  root :controller => 'home', :action => 'index'
  match "/sitemap.xml" , :controller => "sitemap", :action => "sitemap", :format => 'xml' 
  match '/markers', :controller => 'home', :action => 'markers'
end