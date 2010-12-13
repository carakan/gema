# encoding: utf-8

class Reporte < ActiveRecord::Base
  attr_accessor :variables, :texts, :template, :engine_report

  REX_EXTRACT_DATA = /\S*(\*\*[a-z_]+\*\*)\S*/

  REX_EXTRACT_VARIABLES = /\S*(\+\+[a-z_]+\+\+)\S*/

  def extract_variables(pattern)
    @template.scan(pattern).flatten
  end

  # 
  def generate_variables(pattern, keys)
    @variables = self.extract_variables(pattern).collect{|variable| variable.delete(keys)}
  end

  def texto_i18n
    if I18n.locale == :es
      "  #{self.texto_es}"
    else
      "  #{self.texto_en}"
    end
  end

  def texto_i18n=(text)
    if I18n.locale == :es
      texto_es = text
    else
      texto_en = text
    end
  end

  def extract_text(pattern)
    results = [@template]
    results_temp = []
    self.extract_variables(pattern).each do |variable|
      count = 0
      results.each do |result|        
        results_temp[count] = result.split(variable)
        count += 1
      end
      results = results_temp.flatten
    end
    @texts = results
  end

  # Concats variables and prepare data and report for create pdf
  def prepare_report(instancia, pattern = Reporte::REX_EXTRACT_DATA, keys = "**")
    @template = texto_i18n
    extract_text(REX_EXTRACT_VARIABLES)
    generate_variables(REX_EXTRACT_VARIABLES, "++")
    result = ""
    index = 0
    @texts.each do |text|
      result << text
      result << instancia.send(@variables[index]) if @variables[index]
      index += 1
    end

    @template = result
    extract_text(pattern)
    generate_variables(pattern, keys)
  end

  # Set the class report for generate
  def self.set_instance(name_report)
    template = Reporte.find_by_clave(name_report)
    template.engine_report = template.nombre_clase.constantize.new(:page_size => 'LETTER', :page_layout => :landscape, :margin => [40, 50, 40, 60])
    template.print_bottom()
    template.engine_report.font_size 9
    template
  end

  def print_bottom
    self.engine_report.font_size 7
    message =<<-EOF
      · Formato números de solicitud: SM-0000-00 / Formato números de publicación: 111111 / Formato números de registro: 22222-C /
    EOF
    self.engine_report.number_pages message, [self.engine_report.bounds.right - 680, 5]
    message =<<-EOF
      Formato números de solicitud de renovación: SR-0000-00 / Formato números de renovación: 33333-A
    EOF
    self.engine_report.number_pages message, [self.engine_report.bounds.right - 676, -5]
    message =<<-EOF
      · Las fechas se refieren a fecha de presentación de la solicitud o concesión del último registro o renovación.
    EOF
    self.engine_report.number_pages message, [self.engine_report.bounds.right - 680, -15]
  end

  # generate report in pdf
  def to_pdf(data)
    I18n.locale = data.idioma
    prepare_report(@engine_report)
    if data
      @engine_report.dataset = data
      if data.carta
        @engine_report.observacion = data.carta
      end
    end
    index = 0
    @texts.each do |text|
      @engine_report.text(text, :inline_format => true)
      @engine_report.send(@variables[index]) if @variables[index]
      index += 1
    end
    I18n.locale = :es
    @engine_report.render
  end

  # Realiza la creación del reporte para un cruce o busqueda
  def self.crear_reporte(reporte_marca)
    if reporte_marca.for_cruce? || reporte_marca.for_solicitud?
      if reporte_marca.for_cruce? 
        report = Reporte.set_instance("cruce_report")
      elsif reporte_marca.for_solicitud?
        report = Reporte.set_instance("solicitud_marca")
      end
      report.engine_report.marcas = [reporte_marca.marca_foranea]
      report.engine_report.titulares = Marca.first(:conditions => {:id => reporte_marca.marca_ids_serial}).titulares.join(", ")
      report.engine_report.importacion = reporte_marca.importacion
    elsif reporte_marca.tipo_reporte == ReporteMarca::TIPO["Busqueda"]
      report = Reporte.set_instance("busqueda_report")
      report.engine_report.busqueda = reporte_marca.busqueda
      report.engine_report.clases = reporte_marca.consulta.parametros[:clases] if reporte_marca.consulta
    elsif reporte_marca.tipo_reporte == ReporteMarca::TIPO["Lista Publicacion"]
      report = Reporte.set_instance("lista_publicacion")
      marcas = Marca.find(reporte_marca.marca_ids_serial)
      report.engine_report.marcas = marcas
      report.engine_report.titulares = marcas.first.titulares.join(", ")
      report.engine_report.importacion = reporte_marca.importacion
    end
    report.to_pdf(reporte_marca)
  end
end
