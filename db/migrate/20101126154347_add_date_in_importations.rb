# encoding: utf-8
class AddDateInImportations < ActiveRecord::Migration
#  def self.up
#   change_table :importaciones do |t|
#     t.datetime :fecha_limite
#     t.datetime :fecha_limite_orpan
#    end

#        texto_busqueda_es =<<-RTM
# *logo_orpan**

# b>REPORTE DE BÚSQUEDA</b>

# enominación:     ++palabra_busqueda++
#clase (s) Int:    ++clase_en_busqueda++
#fecha:    ++fecha_reporte++

#resultados

#*tabla_reporte**

#*analisis**
#   RTM

 #  texto_busqueda_en =<<-RTM
#*logo_orpan**

#b>SEARCH REPORT</b>

#ord:     ++palabra_busqueda++
#nt. Class (es):    ++clase_en_busqueda++
#ate (dd/mm/yy):    ++fecha_reporte++

#esults

#*tabla_reporte**

#*analisis**
#   RTM

#   texto_cruce_es =<<-RTM
#*logo_orpan**
#+fecha_reporte++

#stimados señores:

#a presente es para informarles que en la edicion Nro ++edicion_gaceta++ de la Gaceta Oficial de Bolivia Nro ++numero_gaceta++ puesta en circulación en fecha ++fecha_gaceta++ se ha publicado la siguiente solicitud de registro de signo distintivo

#*mini_ficha**

#ue consideramos similar a la (s) siguientes marca (s) a nombre de <b>++titulares++</b>:

#*tabla_reporte**

#*analisis**

#l plazo para interponer oposicion contra la marca arriba referida vence el ++fecha_vencimiento++ por lo que rogamos enviarnos sus instrucciones hasta el dia ++fecha_vencimiento_orpan++

#staremos atentos a sus instrucciones sobre el particular.

#ordiales saludos,
#     RTM

#     texto_cruce_en =<<-RTM
#*logo_orpan**
#+fecha_reporte++

#ear Sirs:

#n ++fecha_gaceta++ , the following trademark application was published in the Bolivian Official Gazzette issue Nr. ++numero_gaceta++ filed by:

#*mini_ficha**

#ur watch service system has identified this application to be similar to the following trademark owned by <b>++titulares++</b>:

#*tabla_reporte**

#*analisis**

#he deadline to file oppositions expires on ++fecha_vencimiento++, Please send us your instructions no lather than ++fecha_vencimiento_orpan++

#ours faithfully,
#     RTM

#   Reporte.all.each { |row| row.destroy }

#   Reporte.create(:texto_es => texto_busqueda_es, :texto_en => texto_busqueda_en, :nombre_clase => "BusquedaReport", :clave => "busqueda_report")
#   Reporte.create(:texto_es => texto_cruce_es, :texto_en => texto_cruce_en, :nombre_clase => "CruceReport", :clave => "cruce_report")
# end

# def self.down
#   change_table :importaciones do |t|
#     t.remove :fecha_limite, :fecha_limite_orpan
#   end
# end
end
