# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class ReportBase < Prawn::Document
  attr_accessor :dataset, :date_report, :name_person, :marca, :observacion

  def miniFicha
    if @marca.nil?
      @marca = Marca.first
    end
    if @observacion.nil?
      @observacion = "alguna observacion"
    end

    datos =<<-TR
<font size=\"24\"><color rgb=\"#123456\">#{@marca.nombre}</color></font>
<b>Clase #{@marca.clase_id}</b>
<i><font size=\"15\">#{@marca.titulares.collect{|representante| "#{representante.nombre}\n"}.join(", ")}</font></i>
<b>Número de solicitud:</b> #{@marca.numero_solicitud}
<b>Fecha publicación:</b> #{I18n.l(@marca.fecha_publicacion, :format => :long) if @marca.fecha_publicacion}
<b>Número publicación </b>#{@marca.numero_publicacion}
    TR

    descripcion =<<-TR
<b>Observaciones</b>
#{@observacion}
    TR

    data = [[datos, descripcion]]
    table(data, :cell_style => {:borders => []}) do
      rows(1..2).width = 200
      cells.style(:size => 10, :inline_format => true)
    end
  end

  def fechaReporte
    if @date_report.nil?
      @date_report = Date.today
    end
    text "La Paz, #{I18n.l(@date_report, :format => :long)}"
  end

  def logo_orpan
    create_stamp("logo_orpan") do
      image "#{Rails.root}/public/images/logo-orpan.jpg", :vposition => -30, :fit => [100, 100]
    end
    stamp("logo_orpan")
  end

  def logoOrpan
    logo_orpan
  end
end
