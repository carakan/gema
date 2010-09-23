# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
# Copiado y testeado para poder cambiar mayusculas y minusculas con acentos y ñ
String.class_eval do
  #alias_method :old_upcase, :upcase
  #def upcase
  #  self.gsub( /\303[\240-\277]/ ) do |match|
  #    match[0].chr + (match[1] - 040).chr
  #  end.old_upcase
  #end
  #
  #alias_method :old_downcase, :downcase
  #def downcase
  #  self.gsub( /\303[\200-\237]/ ) do |match|
  #    match[0].chr + (match[1] + 040).chr
  #  end.old_downcase
  #end

  # Cambia acentos y dierisis
  def cambiar_acentos()
    self.gsub(/[áéíóúäëöü]/) do |str|
      case
        when ["á", "ä"].include?(str)
          str = 'a'
        when ["é", "ë"].include?(str) 
          str = 'e'
        when str == "í" 
         str = 'i' 
        when ["ó", "ö"].include?(str)
          str = 'o'
        when ["ú", "ü"].include?(str)
          str = "u"
      end
    end
  end

end

