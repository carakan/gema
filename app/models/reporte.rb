class Reporte < ActiveRecord::Base
  attr_accessor :variables, :texts, :template

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

  # generate report in pdf
  def to_pdf(data)
    reporte = nombre_clase.constantize.new(:page_size => 'LETTER', :page_layout => :landscape )
    #reporte.number_pages "<page> de <total>", [reporte.bounds.right - 50, 0]
    reporte.font_size 9
    prepare_report(reporte)
    reporte.dataset = data
    if data.carta
      reporte.observacion = data.carta
    end
    index = 0
    @texts.each do |text|
      reporte.text(text, :inline_format => true)
      reporte.send(@variables[index]) if @variables[index]
      index += 1
    end
    reporte.render
  end

  # Realiza la creación del reporte para un cruce o busqueda
  def self.crear_reporte(reporte_marca)
    if reporte_marca.importacion_id?
      report = Reporte.find_by_clave("cruce_report")
      report.to_pdf(reporte_marca)      
    else
      report = Reporte.find_by_clave("busqueda_report")
      report.to_pdf(reporte_marca)
    end
  end
end
