module Proyecto::CorrespondenciasHelper
  def next_email(proyecto, email)
    correspondencias = proyecto.correspondencias.where(["created_at > ?", email.created_at]).order("created_at")
    if !correspondencias.empty?
      link_to("Siguiente", proyecto_proyecto_correspondencia_path(proyecto, correspondencias.first), :style => "float:right; padding:5px;", :class => "next-email", :"data-selector" => "#tabs-1")
    end
  end

  def previus_email(proyecto, email)
    correspondencias = proyecto.correspondencias.where(["created_at < ?", email.created_at]).order("created_at DESC")
    if !correspondencias.empty?
      link_to("Anterior", proyecto_proyecto_correspondencia_path(proyecto, correspondencias.first), :style => "float:left; padding:5px;", :class => "previus-email", :"data-selector" => "#tabs-1")
    end
  end
end
