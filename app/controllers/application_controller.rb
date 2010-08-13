# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  before_filter :set_page
  before_filter :set_user_session, :if => :user_signed_in?

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  layout lambda{ |controller| controller.request.xhr? ? false : "application" } 

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

protected
  # Pregunta si el usuario esta logueado
  def authenticate_user!
    redirect_to new_login_url if session[:usuario].nil? or session[:usuario][:id].nil?
  end

  # Indica si el usuario ha ingresado al sistema
  def user_signed_in?
    return false if session[:usuario].nil? or session[:usuario][:id].nil?
    not session[:usuario][:id].nil?
  end

  # Ordena los parametros que son usados en orden eliminando los inecesarios
  def order_query_params(extra = {})
    options = extra.merge( convert_keys_to_sym( params ) )

    [:action, :controller, :commit].each { |v| options.delete(v) }
    unless options[:order].nil?
      direction = ( options[:direction] || "ASC" )
      options.delete(:direction)
      params[:order] = options[:order]
      params[:direction] = direction
      options[:order] = "#{options[:order]} #{direction}"
    end

    options.merge(:page => @page)
  end

  def convert_keys_to_sym(h)
    h.keys.map(&:to_sym).zip(h.values).inject({}) { |h, v| h[v.first] = v.last; h }
  end
  
  helper_method :user_signed_in?

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
    UsuarioSession.current_user = session[:usuario]
  end

end
