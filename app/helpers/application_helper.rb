# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
#
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def facebook_select(f, attr)
    at = attr.to_s.gsub(/_id.*$/, '').pluralize
    f.select attr, f.object.send(at.to_sym).map { |v| [v.to_s, v.id] }, {}, {:multiple => true }
  end

  # Creates the links show, edit, destroy
  def links(klass, options={})
    ['edit', 'destroy'].inject([]) do |t, m|
      t << gema_method_path(m, klass)
    end.join(" ").html_safe
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
    "<span class='#{val} pad-right-img'>#{valido val}</span>".html_safe
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
    if [Date, Time, DateTime, ActiveSupport::TimeWithZone].include? fec.class
      l fec, :format => format
    end
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
    url = params.merge(:order => field, :direction => direction)
    link_to title, url, :class => css
  end

  # Para poder localizar la fecha
  def lo(data, options = {})
    if[Date, Time, DateTime, ActiveSupport::TimeWithZone].include? data.class
      l data, options
    end
  end

  # Presenta el error
  def view_error(f, attr)
    "<span class=\"error\">#{f.object.errors[attr].join(", ")}</span>".html_safe if f.object.errors[attr]
  end

  def last_importation
    importacion = Importacion.last(:conditions => {:tipo => ["lp", "lr"]})
    link_to("Reporte lista publicacion", lista_path(importacion))
  end

  #Metodos que permiten generar los links para añadir y eliminar un elemento html en un formulario
  def remove_child_link(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this);")
  end

  def add_child_link(name, f, method, options = {})
    fields = new_child_fields(f, method, options)
    link_to_function(name, ("insert_fields(this, \"#{method}\", \"#{escape_javascript(fields)}\")"))
  end

  def new_child_fields(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new

    options[:partial] ||= method.to_s.singularize + "_fields"
    options[:form_builder_local] ||= :f
    form_builder.fields_for(method, options[:object], :child_index => "new_#{method}") do |f|
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
    end
  end
end
WillPaginate::ViewHelpers.pagination_options[:previous_label] = '<<'
WillPaginate::ViewHelpers.pagination_options[:next_label] = '>>'

