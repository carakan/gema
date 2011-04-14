module Proyecto::CorrespondenciasHelper
  def next_email(proyecto, email, tab_selector = "tab_selector")
    correspondencias = proyecto.correspondencias.where(["created_at > ?", email.created_at]).order("created_at")
    if !correspondencias.empty?
      link_to(image_tag("icons/right.png", :size => "16x16"), proyecto_proyecto_correspondencia_path(proyecto, correspondencias.first), :style => "float:right; padding:5px;", :class => "next-email", :"data-selector" => tab_selector)
    end
  end

  def previus_email(proyecto, email, tab_selector = "tab_selector")
    correspondencias = proyecto.correspondencias.where(["created_at < ?", email.created_at]).order("created_at DESC")
    if !correspondencias.empty?
      link_to(image_tag("icons/left.png", :size => "16x16"), proyecto_proyecto_correspondencia_path(proyecto, correspondencias.first), :style => "float:left; padding:5px;", :class => "previus-email", :"data-selector" => tab_selector)
    end
  end
end
