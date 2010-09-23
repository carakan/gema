# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
# Copiado y testeado para poder cambiar mayusculas y minusculas con acentos y ñ
if RUBY_VERSION === '1.8.7'
  require File.join(File.dirname(__FILE__), '1.8.7/string187.rb')
elsif RUBY_VERSION === '1.9.2'
  require File.join(File.dirname(__FILE__), '1.9.2/string192.rb')
end

String.class_eval do

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

