class Reporte < ActiveRecord::Base
  attr_accessible :texto_en, :texto_es

  # regular expresion for scan strings
  # [\*\*[a-zA-Z]+\*\*]*

  REX_EXTRACT_DATA = /\S*(\*\*[a-zA-Z]+\*\*)\S*/

  def extract_variables()
     self.texto_es.scan(Reporte::REX_EXTRACT_DATA).flatten
  end


  def extract_text()
    variables = self.extract_variables()
    results = [self.texto_es]
    results_temp = []
    variables.each do |variable|
      count = 0
      results.each do |result|        
        results_temp[count] = result.split(variable)
        count += 1
      end
      results = results_temp.flatten
    end
    results
  end

  
end
