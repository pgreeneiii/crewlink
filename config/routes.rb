Rails.application.routes.draw do
  devise_for :users, :controllers => {omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations'}
  get 'gamers/index'
  root to: 'dashboards#index'

  resources :conversations, only: [:index, :show, :destroy] do
     member do
        post :reply
     end
     member do
        post :restore
     end
     collection do
        delete :empty_trash
     end
     member do
        post :mark_as_read
     end
  end

  resources :messages, only: [:new, :create]
  resources :dashboards, only: [:index]
  post "/change_status", :controller => "dashboards", :action => "change_status"


  match 'users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  # Routes for the Library resource:
  # CREATE
  get("/load_library", {:controller => "libraries", :action => "load"})
  post "/create_library", :controller => "libraries", :action => "create"

  # READ
  get "/libraries", :controller => "libraries", :action => "index"

  # UPDATE
  post "/update_library/:id", :controller => "libraries", :action => "update"
  post "/toggle_library_status/:id", :controller => "libraries", :action => "toggle"

  # DELETE
  get "/delete_library/:id", :controller => "libraries", :action => "destroy"
  #------------------------------

  # Routes for the Game resource (SHOULD BE ADMIN ONLY):
  # CREATE
  get "/games/new", :controller => "games", :action => "new"
  get("/refresh_games", {:controller => "games", :action => :refresh})
  post "/create_game", :controller => "games", :action => "create"

  # READ
  get "/games", :controller => "games", :action => "index"
  get "/games/:id", :controller => "games", :action => "show"

  # UPDATE
  get "/games/:id/edit", :controller => "games", :action => "edit"
  post "/update_game/:id", :controller => "games", :action => "update"

  # DELETE
  get "/delete_game/:id", :controller => "games", :action => "destroy"
  #------------------------------


  # Routes for the Friend resource:
  # EDIT
  post "/make_preferred", :controller => "friends", :action => "make_preferred"
  post "/end_preferred", :controller => "friends", :action => "end_preferred"

  # READ
  get "/friends", :controller => "friends", :action => "index"
  get "/find_friends", :controller => "friends", :action => "find_friends"

  #------------------------------

  get "/requests/index", :controller => "requests", :action => "index"
  post "accept_request", :controller => "requests", :action => "accept_request"
  post "/send_request", :controller => "requests", :action => "send_request"
  post "/remove_friend/:id", :controller => "requests", :action => "remove_friend"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
