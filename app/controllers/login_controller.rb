# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class LoginController < ApplicationController
  def new
    @usuario = Usuario.new

    unless session[:usuario] and session[:usuario][:id]
      render "new"
    else
      render "logged"
    end
  end

  def create
    if usuario = Usuario.find_login_password(params[:usuario][:login], params[:usuario][:password])
      session[:usuario] = { :id => usuario.id, :nombre => usuario.nombre, :rol_id => usuario.rol_id }
      flash[:notice] = 'Usted a ingresado correctamente'
      redirect_to busquedas_url
    else
      @usuario = Usuario.new
      flash[:error] = 'El usuario o contraseña es incorrecto'
      render 'new'
    end
  end

  def destroy
    session[:usuario] = {}
      flash[:notice] = 'Usted ha salido correctamente'
    redirect_to new_login_url
  end
end
