Talkroom::Application.routes.draw do


  resources :inquiries

  resources :buying_histories

  resources :ios_transactions

  resources :ca_rewards

  resources :friends

  resources :lists
  match "/get_all_users" => "api#get_all_users"#デバッグ用
  match "/get_recent_rooms" => "api#get_recent_rooms"
  match "/get_room_summary_data" => "api#get_room_summary_data"
  match "/get_search_users" => "api#get_search_users"
  match "/get_oneside_rooms" => "api#get_oneside_rooms"
  match "/get_bothside_rooms" => "api#get_bothside_rooms"
  match "/get_detail_profile" => "api#get_detail_profile"
  match "/get_user_rooms" => "api#get_user_rooms"
  match "/get_user_profile" => "api#get_user_profile"
  match "/get_room_message" => "api#get_room_message"
  match "/get_visits" => "api#get_visits"
  match "/get_point" => "api#get_point"
  match "/consume_point" => "api#consume_point"
  match "/change_private_room" => "api#change_private_room"
  
  match "/update_profile" => "api#update_profile"
  match "/update_detail_profile" => "api#update_detail_profile" 
  
  match "/create_message" => "api#create_message"
  match "/create_account" => "api#create_account"
  match "/create_friends" => "api#create_friends"
  match "/upload_image" => "api#upload_image"
  
  match "/check_login" => "api#check_login"
  match "/car_pointback" => "api#car_pointback"
  match "/send_mail" => "api#send_mail"
  
  match "/verify_receipt" => "api#verify_receipt", :defaults => {:format => :json}
  
  # トークン利用の例
  match "/example_token" => "api#example_token"
  
  resources :visits

  resources :rooms

  resources :messages

  #get "sessions/callback"
  #get "welcome/index"
  
  #match "/auth/:provider/callback" => "sessions#callback"  
  #match "/logout" => "sessions#destroy", :as => :logout  
  
  root :to => 'welcome#index' 
  get 'lists', :to=> 'lists#index', :as=>:user_root

  devise_for :lists, :controllers => { :omniauth_callbacks => "lists/omniauth_callbacks" }
  
  devise_scope :list do
    get 'sign_in.list', :to => 'devise/sessions#new', :as => :new_user_session
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_session
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
