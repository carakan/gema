module Proyecto::InstruccionDetallesHelper
  def nested_instruccion_detalles(instruccion_detalles)
    instruccion_detalles.map do |instruccion_detalles, sub_instruccion_detalles|
      render(instruccion_detalles) + content_tag(:div, nested_instruccion_detalles(sub_instruccion_detalles), :class => "nested_instruccion_detalles")
    end.join.html_safe
  end

  def links_tareas(klass, estado_tarea)
    case (estado_tarea)
      when "pendiente" then link_to "Entregar", entrega_proyecto_proyecto_instruccion_instruccion_detall_path(@proyecto, instruccion_detall.instruccion, instruccion_detall), :class => 'terminada'
    end
  end
end
