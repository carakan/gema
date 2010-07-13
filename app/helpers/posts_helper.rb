module PostsHelper
  def adjuntos(adjunto)
    if adjunto
      "<span class=\"adjunto\" title=\"Existen adjuntos\"></span>"
    end
  end
end
