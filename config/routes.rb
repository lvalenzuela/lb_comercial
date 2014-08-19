Rails.application.routes.draw do
  root "site#index"

  match "auth/:provider/callback", to: "users#facebook_login", via: [:get , :post]
  match "auth/failure", to: redirect("/"), via: [:get , :post]
  match "signout", to: "users#logout", as: "signout", via: [:get , :post]

  resources :users do
    collection do
      post "create"
      post "update"
      post "longbourn_login"
      post "register_user_contact"
      post "modify_contact_data"
      get "user_logout"
      post "register_lead"
      post "create_contact_person"
    end
  end

  resources :site do
    collection do
      get "course_list"
      get "new_contact_person"
      get "index"
      get "available_courses"
      post "available_courses"
      post "load_extra_content"
      get "confirm_purchase"
      get "register_purchase"
      get "register_invoice"
      get "signup"
      get "edit_user"
      get "organization_signup"
      get "registration_success"
      get "login"
      get "play_tha_game"
      post "test_results"
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
