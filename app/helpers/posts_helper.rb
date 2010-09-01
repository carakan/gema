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
      when "index" then text, method, css = "Lista", :posts_path, "list ajax"
      when "new" then text, method, css = "Nuevo comentario", :new_post_path, "new post"
    end

    link_to text, send(method, { :postable_id => klass.id, :postable_type => klass.class}),  :class => css
  end
end
