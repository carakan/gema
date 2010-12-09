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

    marca_header = [I18n.t("nombre marca"), I18n.t("tipo marca"), I18n.t("imagen marca"), I18n.t("clase marca"),
      I18n.t("fecha solicitud marca"), I18n.t("numero publicacion marca"),
      I18n.t("titulares marca"), I18n.t("observaciones marca")]

    marcas_table = []
    count = 0
    @marcas.each do |marca|
      fecha_solicitud = "#{I18n.l(marca.fecha_marca.to_date, :format => :long) if marca.fecha_marca}"

      marcas_table[count] = ["#{marca.nombre}", "#{marca.tipo_signo.try(:sigla) if marca.tipo_signo}", "", "#{marca.clase_id}", "#{fecha_solicitud}",
        "#{marca.numero_marca}",
        "#{marca.titulares.collect{|representante| "#{representante.nombre}"}.join(", ")}", "#{marca.productos}"]
      count += 1
    end

    data = [marca_header] + marcas_table

    the_x = 0
    the_y = 0

    table(data, :cell_style => {:border_width => 1}) do |t|
      t.row(0).style :background_color => 'cccccc', :style => :bold, :align => :center, :valign => :center
      t.rows(1..7).width = 120
      t.cells.style(:size => 8, :inline_format => true)
      the_x = t.cells[1,2].x
      the_y = t.cells[1,2].y

      @marcas.each do |marca|
        image("#{Rails.public_path}/#{marca.adjuntos.first.archivo.url(:mini)}" , :at => [the_x + 135, the_y - 25], :fit => [80, 80]) if !marca.adjuntos.empty?
      end
      t.column(0).style(:width => 130)
      t.column(1..3).style(:width => 35)
      t.column(4).style(:width => 80)
      t.column(5).style(:width => 50)
      t.column(2).style(:width => 100)
      t.column(7).style(:width => 300)
    end
  end

  def fecha_reporte
    if @date_report.nil?
      @date_report = Date.today
    end
    "#{I18n.l(@date_report, :format => :long)}"
  end

  def logo_orpan
    create_stamp("logo_orpan") do
      image "#{Rails.root}/public/images/logo-orpan.jpg", :at => [600, 550], :fit => [100, 50]
    end
    stamp("logo_orpan")
  end
end
