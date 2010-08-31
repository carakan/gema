module PostsHelper
  def adjuntos(adjunto)
    if adjunto
      "<span class=\"adjunto\" title=\"Existen adjuntos\"></span>"
    end
  end

  def link_nuevo_post(klass)   
    link_to "Nuevo comentario", new_post_path('data-title' => 'Nuevo post', :postable_type => klass.class, :postable_id => klass.id ), :class => 'new post'
  end
end
