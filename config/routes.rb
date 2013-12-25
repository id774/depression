RailsApp::Application.routes.draw do
  root :to => 'stories#new'
  resources :stories,
    :only => [:new, :create, :index, :show]
end
