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
      when "destroy" then link_to "borrar", klass, :method => :delete, :confirm => "Esta seguro?", :class => 'delete', :title => "Borrar", :remote => true
      else ""
    end
  end
  
  def verdad?(val)
    #val == true ? t("yes") : t("no")
    val ? "Si" : "No"
  end
end
WillPaginate::ViewHelpers.pagination_options[:previous_label] = '<<'
WillPaginate::ViewHelpers.pagination_options[:next_label] = '>>'
