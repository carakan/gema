class Reporte < ActiveRecord::Base
  attr_accessor :variables, :texts, :template, :engine_report

  REX_EXTRACT_DATA = /\S*(\*\*[a-z_]+\*\*)\S*/

  REX_EXTRACT_VARIABLES = /\S*(\+\+[a-z_]+\+\+)\S*/

  def extract_variables(pattern)
    self.texto_es.scan(pattern).flatten
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
    template.engine_report = template.nombre_clase.constantize.new(:page_size => 'LETTER', :page_layout => :landscape, :margin => [40, 50, 30, 60])
    template.engine_report.font_size 9
    template
  end

  # generate report in pdf
  def to_pdf(data)
    I18n.locale = data.idioma
    prepare_report(@engine_report)
    @engine_report.dataset = data
    if data.carta
      @engine_report.observacion = data.carta
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
    if reporte_marca.importacion_id?
      report = Reporte.set_instance("cruce_report")
      report.engine_report.marcas = reporte_marca.reporte_marca_detalles.collect{|detalle| detalle.marca_foranea}
    else
      report = Reporte.set_instance("busqueda_report")
      report.engine_report.busqueda = reporte_marca.busqueda
      report.engine_report.clases = reporte_marca.consulta.parametros[:clases].join(", ")
    end
    report.to_pdf(reporte_marca)
  end
end
