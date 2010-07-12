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

  def verdad(val)
    #val == true ? t("yes") : t("no")
    val ? "Sí" : "<span class='error'>No</span>"
  end

  # localiza la fecha
  def fecha(fec, format = :short)
    if format == :short
      format = ''
    else
      format = '%d %B de %Y a hrs. %H:%I'
    end
    l fec, :format => format
  end

  def fecha_hora(fec, format = :short)
    if format == :short
      format = '%d %b %Y  %H:%I'
    else
      format = '%d %B de %Y a hrs. %H:%I'
    end
    l fec, :format => format
  end

  # Indica si hay cambio en el campo
  def cambio(klass, attr, presentar = nil)
    if !klass.cambios.nil? and klass.cambios.include?(attr.to_s)
      attr = attr.to_s.gsub(/(.*)_id$/, '\1') if !!(attr.to_s =~ /.*_id$/)
      if presentar.nil?
        "<span class='cambio'>#{klass.send(attr)}</span>"
      else
        "<span class='cambio'>#{presentar}</span>"
      end
    else
      if presentar.nil?
        klass.send(attr)
      else
        presentar
      end
    end
  end

  def listado_facebook(klass, caption, options = {})
  end

end
WillPaginate::ViewHelpers.pagination_options[:previous_label] = '<<'
WillPaginate::ViewHelpers.pagination_options[:next_label] = '>>'
