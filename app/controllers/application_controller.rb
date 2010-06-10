# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  before_filter :set_page

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  layout lambda{ |controller| controller.request.xhr? ? false : "application" } 

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

private
  def set_page
   @page = 1
   @page = params[:page] unless params[:page].nil?
  end
end
