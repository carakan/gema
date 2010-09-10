# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Creates the links show, edit, destroy
  def links(klass, options={})
    ['edit', 'destroy'].inject([]) do |t, m|
      t << gema_method_path(m, klass)
    end.join(" ")
  end

  # Set the method and link for  new, edit, destroy, show
  def gema_method_path(m, klass)
    k = klass.class.to_s.underscore
    case(m)
      when "new" then link_to "Nuevo", send("new_#{k}_path", klass) 
      when "show" then link_to "ver", klass, :class => "show", :title => "Ver", :class => 'show'
      when "edit" then link_to "editar", send("edit_#{k}_path", klass), :class => "edit", :title => "Editar"
      when "destroy" then link_to "borrar", klass, :class => 'delete', :title => "Borrar", 'data-remote' => true
      else ""
    end
  end  

  def tr_error(klass)
    if klass.try(:valido)
      "<tr>"
    else
      "<tr class=\"error\">"
    end
  end


  def valido(val)
    val ? "Si": "No"
  end
  alias verdad valido

  def valido_img(val)
    "<span class='#{val} pad-right-img'>#{valido val}</span>"
  end

  # localiza la fecha
  def fecha(fec, format = :short)
    if :short == format
      format = '%d %b %Y'
    else
      format = '%d %B de %Y a hrs. %H:%I'
    end
    l fec, :format => format
  end

  def fecha_hora(fec, format = :short)
    if :short == format
      format = '%d %b %Y  %H:%I'
    else
      format = '%d %B de %Y a hrs. %H:%I'
    end
    l fec, :format => format
  end

  def sort_order(title, field, options = {})
    css = ''
    direction = 'asc'
    if params[:order] == field
      if params[:direction] == 'asc'
        css = direction = 'desc'
      else
        css = direction = 'asc'
      end
    end
    url = { :controller => params[:controller], :action => params[:action], :order => field, :direction => direction }
    link_to title, url, :class => css
  end

  # Para poder localizar la fecha
  def lo(data, options = {})
    if[Date, Time, DateTime, ActiveSupport::TimeWithZone].include? data.class
      l data, options
    end
  end

end
WillPaginate::ViewHelpers.pagination_options[:previous_label] = '<<'
WillPaginate::ViewHelpers.pagination_options[:next_label] = '>>'

