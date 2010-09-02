ActionController::Routing::Routes.draw do |map|
  map.resources :contactos

  map.resources :consultas

  map.resources :importaciones, :member => { :cruce => :get, :descarga => :get, :reportes => :get }

  map.resources :adjuntos

  map.resources :posts

  map.resources :paises

  map.resources :tipo_marcas

  map.resources :usuarios

  map.resources :representantes, :member => { :create_post => :post, :show => :get }, :collection => { :buscar => :get }

  #map.resources :titulares, :collection => { :buscar => :get }

  #map.resources :agentes, :collection => { :buscar => :get }

  map.resources :tipo_signos

  map.resources :testes

  map.resources :clases

  map.resources :marcas, :member => { :create_post => :post, :ver => :get }

  map.resources :solicitud_marcas

  map.resources :lista_publicaciones

  map.resources :busquedas, :collection => { :cruce => :get, :verificar_cruce => :get }

  map.resources :solicitudes, :member => { :importado => :get }

  # Plugin
  map.resources :roles

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.

  map.resources :login

  map.logout '/logout', :controller => 'login', :action => 'destroy'

  map.root :controller => "login", :action => 'new'
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
