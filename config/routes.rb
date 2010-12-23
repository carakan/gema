# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
Rails.application.routes.draw do

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

  resources :usuarios

  resources :representantes do
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
      get :avanzada
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
