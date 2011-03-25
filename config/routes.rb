# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
Rails.application.routes.draw do

  namespace(:proyecto){ resources :correspondencias }

  resources :marca_estados

  resources :reportes
  
  devise_for :usuarios do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
  end

  resources :reporte_marcas do
    collection do
      get :cruces
      post :cruce
      
    end

    member do
      get :download
      get :download_advanced
    end
  end

  resources :contactos

  resources :consultas do
    collection do
      post :cruce 
    end
  end

  resources :importaciones do
    collection do
      get :cruce
    end

    member do
      get :descarga
      get :reportes
    end
  end

  resources :adjuntos

  resources :posts

  resources :paises

  resources :tipo_marcas

  resources :usuarios do
    member do
      post :create_usuario
      put :update_usuario
    end
  end

  resources :representantes do
    member do
      get :representante_contactos
    end
    collection do
      get :buscar
    end
  end

  resources :tipo_signos

  resources :testes

  resources :clases

  resources :marcas do
    member do
      post :create_post
      get :ver
      get :quitar_lema
      get :adicionar_lemas
    end
    collection do
      get :lemas_comerciales
      
    end
  end

  resources :solicitud_marcas

  resources :listas do
    collection do
      post :reporte
    end
  end

  resources :busquedas do
    collection do
      get :cruce 
      get :verificar_cruce
      get :busqueda_avanzada
      post :busqueda_avanzada
      get :avanzada
      get :titulares
    end
  end

  resources :solicitudes do
    member { get :importado }
  end

  resources :roles

  #resources :login

  #match 'logout' => 'devise/sessions#sign_out'

  #root :to => 'login#new'
  root :to => 'busquedas#index'
end
