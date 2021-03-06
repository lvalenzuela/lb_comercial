Rails.application.routes.draw do
  root "site#index"

  match "auth/:provider/callback", to: "users#facebook_login", via: [:get , :post]
  match "auth/failure", to: redirect("/"), via: [:get , :post]
  match "signout", to: "users#logout", as: "signout", via: [:get , :post]

  ##
  #Informacionales
  ##
  match "ingles-ejecutivo", to: "info#longbourn_executive", via: [:get]
  match "ingles-empresarial", to: "info#longbourn_startup", via: [:get]
  match "instituto-de-ingles", to: "info#longbourn_institute", via: [:get]
  #match "cursos-internacionales", to: "info#cursos_internacionales", via: [:get]

  match "ingles-en-las-condes", to: "info#cursos_en_sede", via: [:get]
  match "cursos-toefl", to: "info#cursos_toefl", via: [:get]
  #match "cursos-ielts", to: "info#cursos_ielts", via: [:get]
  #match "cursos-toeic", to: "info#cursos_toeic", via: [:get]
  match "metodologia-teg", to: "info#teg_method", via: [:get]
  match "cursos-de-ingles-para-empresas", to: "info#cursos_empresas", via: [:get]
  match "contactanos", to: "site#contact_us", via: [:get]
  match "valores-precios-o-tarifas", to: "site#contact_sales_agent", via: [:get]
  match "trabajo-ingles", to: "site#work_with_us", via: [:get]
  match "promociones", to: "promotions#promo_referral", via: [:get]
  match "comparte-longbourn-con-tus-amigos", to: "promotions#promo_referral_landing", via: [:get]

  #Redirect 301#
  get "/jobs_longbourn", to: redirect("/trabajo-ingles")
  get "/ingles_en_sede", to: redirect("/ingles-en-las-condes")
  get "/cursos_empresas", to: redirect("/cursos-de-ingles-para-empresas")
  get "/longbourn_institute", to: redirect("/instituto-de-ingles")
  get "/longbourn_executive", to: redirect("/ingles-ejecutivo")
  get "/longbourn_startup", to: redirect("/ingles-empresarial")
  get "/contactar_agente", to: redirect("/valores-precios-o-tarifas")
  get "/metodologia_teg", to: redirect("/metodologia-teg")
  get "/cursos_toefl", to: redirect("/cursos-toefl")
  get "/site/contact_us", to: redirect("/contactanos")
  get "/quiz", to: redirect("/")
  get "/nuestros-clientes", to: redirect("/")
  get "/jobs", to: redirect("/trabajo-ingles")



  resources :promotions do 
    collection do
      post "send_promo_mail"
      get "register_by_referral"
    end
  end

  resources :users do
    collection do
      #get "user_identification"
      #post "create"
      #post "update"
      #post "longbourn_login"
      #post "register_user_contact"
      #post "modify_contact_data"
      #get "user_logout"
      #post "register_lead"
      #post "create_contact_person"
    end
  end

  resources :site do
    collection do
      get "redirect_view"
      get "course_list"
      #get "new_contact_person"
      get "index"
      #get "available_courses"
      #post "available_courses"
      #get "selected_courses_list"
      #post "load_extra_content"
      #get "confirm_purchase"
      #get "register_purchase"
      #get "register_invoice"
      #get "signup"
      #get "edit_user"
      #get "organization_signup"
      #get "registration_success"
      #get "login"
      #get "play_tha_game"
      #post "test_results"
      #post "search"
      #get "course_details_report"
      get "contact_sales_agent"
      get "contact_us"
      get "work_with_us"
      post "deliver_contact_form"
      post "deliver_sales_contact_form"
      post "deliver_job_form"
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
