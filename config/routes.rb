# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
ActionController::Routing::Routes.draw do |map|
  resources :reporte_marcas do
    collection do
      get :cruces
      get :curce
    end

    member do
      get :download
    end
  end

  resources :contactos

  resources :consultas

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
    member do
      get :create_post
      get :show
    end

    collection do
      get :buscar
    end
  end

  resources :titulares do
    collection do
      get :buscar
    end
  end

  resources :agentes do
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

  resources :lista_publicaciones

  resources :busquedas do
    collection do
      get :cruce 
      get :verificar_cruce
    end
  end

  resources :solicitudes do
    member { get :importado }
  end

  resources :roles

  resources :login

  match 'logout' => 'login#destroy'

  root :to => 'login#new'
end
