# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class ReportBase < Prawn::Document
  attr_accessor :dataset, :date_report, :name_person, :marcas, :observacion

  def mini_ficha
    if @marcas.nil? || @marcas.empty?
      @marcas = []
      @marcas[0] = Marca.first
    end
    if @observacion.nil?
      @observacion = "alguna observacion"
    end

    marca_header = [I18n.t("nombre marca"), I18n.t("tipo marca"), I18n.t("imagen marca"), I18n.t("clase marca"), I18n.t("numero solicitud marca"),
      I18n.t("fecha publicacion marca"), I18n.t("numero publicacion marca"),
      I18n.t("titulares marca"), I18n.t("observaciones marca")]

    marcas_table = []
    count = 0
    @marcas.each do |marca|
      fecha_publicacion = "#{I18n.l(marca.try(:fecha_publicacion), :format => :long) if marca.fecha_publicacion}"

      marcas_table[count] = ["#{marca.nombre}", "#{marca.tipo_marca.try(:sigla) if marca.tipo_marca}", "", "#{marca.clase_id}", "#{marca.numero_solicitud}",
        "#{fecha_publicacion}", "#{marca.numero_publicacion}",
        "#{marca.titulares.collect{|representante| "#{representante.nombre}"}.join(", ")}", "#{@observacion}"]
      count += 1
    end

    data = [marca_header, marcas_table.flatten]

    the_x = 0
    the_y = 0

    table(data, :cell_style => {:border_width => 1}) do |t|
      t.row(0).style :background_color => 'f0f0f0'
      t.row(0).style :"size" => 9
      t.row(1).style :"size" => 9
      t.rows(1..7).width = 120
      t.cells.style(:size => 8, :inline_format => true)
      the_x = t.cells[1,2].x
      the_y = t.cells[1,2].y

      t.cells[1,1].content = "\n"
      @marcas.each do |marca|
        image(marca.adjuntos.first.archivo.url(:mini), :at => [the_x + 210, the_y - 20], :fit => [50, 50]) if !marca.adjuntos.empty?
      end
    end
  end

  def fecha_reporte
    if @date_report.nil?
      @date_report = Date.today
    end
    "La Paz, #{I18n.l(@date_report, :format => :long)}"
  end

  def logo_orpan
    create_stamp("logo_orpan") do
      image "#{Rails.root}/public/images/logo-orpan.jpg", :at => [600, 550], :fit => [100, 50]
    end
    stamp("logo_orpan")
  end
end
