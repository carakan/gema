class LoginController < ApplicationController
  def new
    @usuario = Usuario.new
  end

  def create
    if usuario = Usuario.find_login_password(params[:usuario][:login], params[:usuario][:password])
      session[:usuario] = { :id => usuario.id, :nombre => usuario.nombre, :rol => usuario.rol }
      flash[:notice] = 'Usted a ingresado correctamente'
      redirect_to importaciones_url
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
