# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class ApplicationController < ActionController::Base
  include Rorol::Controllers::Helpers
  before_filter :set_cache_buster

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  before_filter :set_page
  before_filter :set_user_session, :if => :usuario_signed_in?
  before_filter :revisar_permiso!
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  layout lambda{ |controller| controller.request.xhr? ? false : "application" } 

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

protected
  # Pregunta si el usuario esta logueado
  #def authenticate_user!
  #  #redirect_to new_login_url if session[:usuario].nil? or session[:usuario][:id].nil?
  #end

  # Indica si el usuario ha ingresado al sistema
  #def user_signed_in?
  #  return false if session[:usuario].nil? or session[:usuario][:id].nil?
  #  not session[:usuario][:id].nil?
  #end
  #helper_method :user_signed_in?

  # Ordena los parametros que son usados en orden eliminando los inecesarios
  # Retorna el parametro de orden ademas de la pagina para paginación
  def order_query_params(order, direction = 'asc')
    direction = params[:direction] unless params[:direction].nil?
    params[:direction] = ['asc', 'desc'].include?(direction) ? direction : 'asc'
    params[:order] = order if params[:order].nil?
    { :order => "#{params[:order]} #{params[:direction]}", :page => @page }
  end

  # Funcion de para ordenamiento
  def order_by_params( order , direction = 'asc')
    direction = ['asc', 'desc'].include?(params[:direction]) ? params[:direction] : direction
    order = params[:order] || order
    order = "#{order} #{direction}"
  end

  def convert_keys_to_sym(h)
    h.keys.map(&:to_sym).zip(h.values).inject({}) { |h, v| h[v.first] = v.last; h }
  end


  # Si es AJAX presenta OK, sino redirecciona
  def redirect_ajax(klass, notice)
    if request.xhr?
      render :text => 'Ok'
    else
      redirect_to(klass, :notice => notice)
    end
  end

private
  def set_page
   @page = 1
   @page = params[:page] unless params[:page].nil?
  end

  def set_user_session
    UsuarioSession.current_user = current_usuario
  end

   # Overwriting the sign_out redirect path method
  def after_sign_in_path_for(resource_or_scope)
    set_user_session
  end

  def revisar_permiso!
    if UsuarioSession && UsuarioSession.current_user
      permission = Permission.find_by_rol_id_and_controller( UsuarioSession.current_user[:rol_id], params[:controller] )

      if permission
        unless permission.actions[params[:action]]
          flash[:notice] = "Esta área esta restringida."
          redirect_to "/"
        end
      else
        flash[:notice] = "Esta área esta restringida, saliendo del sistema."
        redirect_to '/logout'
      end
    else
      flash[:notice] = "Esta área esta restringida."
      if params[:controller] != "devise/sessions"
        redirect_to '/login'
      end
    end 
  end
end
