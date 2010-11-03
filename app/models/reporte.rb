class Reporte < ActiveRecord::Base

  attr_accessor :variables, :texts

  REX_EXTRACT_DATA = /\S*(\*\*[a-zA-Z]+\*\*)\S*/

  def extract_variables()
    self.texto_es.scan(Reporte::REX_EXTRACT_DATA).flatten
  end

  def generate_variables()
    @variables = self.extract_variables().collect{|variable| variable.delete("**")}
  end

  def texto_i18n
    if I18n.locale == :es
      self.texto_es
    else
      self.texto_en
    end
  end

  def extract_text()
    results = [self.texto_i18n]
    results_temp = []
    self.extract_variables().each do |variable|
      count = 0
      results.each do |result|        
        results_temp[count] = result.split(variable)
        count += 1
      end
      results = results_temp.flatten
    end
    @texts = results
  end

  def prepare_report
    extract_text
    generate_variables
  end


  # simple case for html or text
  def generate_report()
    prepare_report
    result = ""
    index = 0
    @texts.each do |text|
      result << text
      result << self.send(@variables[index])
      index += 1
    end
    return result
  end

  # generate report in pdf
  def to_pdf(data)
    prepare_report
    reporte = nombre_clase.constantize.new(:page_size => 'LEGAL', :page_layout => :landscape )
    reporte.dataset = data
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
