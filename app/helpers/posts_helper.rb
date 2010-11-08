module PostsHelper
  def adjuntos(adjunto)
    if adjunto
      "<span class=\"adjunto\" title=\"Existen adjuntos\"></span>"
    end
  end

  def link_nuevo_post(klass)   
    link_to "Nuevo comentario", new_post_path('data-title' => 'Nuevo post', :postable_type => klass.class, :postable_id => klass.id ), :class => 'new post'
  end

  def link_post(klass, method)
    
    case method
      when "index" then text, method, css, data_title = "Lista de comentarios", :posts_path, "list ajax", 'Lista de comentarios'
      when "new" then text, method, css, data_title = "Nuevo comentario", :new_post_path, "new post", 'Crear comentario'
    end

    link_to text, send(method, { :postable_id => klass.id, :postable_type => klass.class}), 'data-title' => data_title,  :class => css
  end
end
