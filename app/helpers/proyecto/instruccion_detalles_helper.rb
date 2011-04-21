module Proyecto::InstruccionDetallesHelper
  def nested_instruccion_detalles(instruccion_detalles)
    instruccion_detalles.map do |instruccion_detalles, sub_instruccion_detalles|
      render(instruccion_detalles) + content_tag(:div, nested_instruccion_detalles(sub_instruccion_detalles), :class => "nested_instruccion_detalles")
    end.join.html_safe
  end
end
