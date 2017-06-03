Rails.application.routes.draw do
  devise_for :users, :controllers => {omniauth_callbacks: 'omniauth_callbacks'}
  get 'gamers/index'
  root to: 'libraries#index'

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

  #post 'auth/steam/callback' => 'gamers#auth_callback'

  match 'users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  # Routes for the Library resource:
  # CREATE

  #get("/", {:controller => "gamers", :action => "index"})

  get "/libraries/new", :controller => "libraries", :action => "new"
  get("/load_library", {:controller => "libraries", :action => "load"})
  post "/create_library", :controller => "libraries", :action => "create"

  # READ
  get "/libraries", :controller => "libraries", :action => "index"
  get "/libraries/:id", :controller => "libraries", :action => "show"

  # UPDATE
  get "/libraries/:id/edit", :controller => "libraries", :action => "edit"
  post "/update_library/:id", :controller => "libraries", :action => "update"
  post "/toggle_library_status/:id", :controller => "libraries", :action => "toggle"

  # DELETE
  get "/delete_library/:id", :controller => "libraries", :action => "destroy"
  #------------------------------

  # Routes for the Game resource:
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
  # CREATE
  get "/friends/new", :controller => "friends", :action => "new"
  post "/create_friend", :controller => "friends", :action => "create"
  post "/add_friend/:id", :controller => "friends", :action => "add_friend"

  # READ
  get "/friends", :controller => "friends", :action => "index"
  get "/friends/:id", :controller => "friends", :action => "show"

  # UPDATE
  get "/friends/:id/edit", :controller => "friends", :action => "edit"
  post "/update_friend/:id", :controller => "friends", :action => "update"

  # DELETE
  get "/delete_friend/:id", :controller => "friends", :action => "destroy"
  post "/remove_friend/:id", :controller => "friends", :action => "remove_friend"
  #------------------------------

  # Routes for the Gamer resource:
  # CREATE
  get "/gamers/new", :controller => "gamers", :action => "new"
  post "/create_gamer", :controller => "gamers", :action => "create"

  # READ
  get "/gamers", :controller => "gamers", :action => "index"
  get "/gamers/:id", :controller => "gamers", :action => "show"

  # UPDATE
  get "/gamers/:id/edit", :controller => "gamers", :action => "edit"
  post "/update_gamer/:id", :controller => "gamers", :action => "update"

  # DELETE
  get "/delete_gamer/:id", :controller => "gamers", :action => "destroy"
  #------------------------------

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
