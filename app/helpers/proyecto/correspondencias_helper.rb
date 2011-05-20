module Proyecto::CorrespondenciasHelper
  def next_email(proyecto, email, tab_selector = "tab_selector")
    if email.nil?
      email = proyecto.correspondencias.first
    end
    correspondencias = proyecto.correspondencias.where(["orden > ?", email.orden]).order("orden DESC")
    if !correspondencias.empty?
      link_to(image_tag("icons/right.png", :size => "16x16"), proyecto_proyecto_correspondencia_path(proyecto, correspondencias.first), :style => "float:right; padding:5px;", :class => "previus-email", :"data-selector" => tab_selector)
    end
  end

  def previus_email(proyecto, email, tab_selector = "tab_selector")
    if email.nil?
      email = proyecto.correspondencias.last
    end
    correspondencias = proyecto.correspondencias.where(["orden < ?", email.orden]).order("orden")
    if !correspondencias.empty?
      link_to(image_tag("icons/left.png", :size => "16x16"), proyecto_proyecto_correspondencia_path(proyecto, correspondencias.first), :style => "float:left; padding:5px;", :class => "next-email", :"data-selector" => tab_selector)
    end
  end
end
