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

    fecha_publicacion = "#{I18n.l(@marca.fecha_publicacion, :format => :long) if @marca.fecha_publicacion}"
    marca_header = [I18n.t("nombre marca"), I18n.t("clase marca"), I18n.t("numero solicitud marca"),
                    I18n.t("fecha publicacion marca"), I18n.t("numero publicacion marca"),
                    I18n.t("titulares marca"), I18n.t("observaciones marca")]
    marca_table = ["#{@marca.nombre}", "#{@marca.clase_id}", "#{@marca.numero_solicitud}", 
                   "#{fecha_publicacion}", "#{@marca.numero_publicacion}",
                   "#{@marca.titulares.collect{|representante| "#{representante.nombre}"}.join(", ")}", "#{@observacion}"]

    data = [marca_header, marca_table]

    table(data, :cell_style => {:border_width => 1}) do
      row(0).style :background_color => 'f0f0f0'
      row(0).style :"size" => 9
      row(1).style :"size" => 9
      rows(1..7).width = 150
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
