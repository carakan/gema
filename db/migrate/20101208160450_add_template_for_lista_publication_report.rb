# encoding: utf-8
class AddTemplateForListaPublicationReport < ActiveRecord::Migration
#  def self.up
 #   text_es =<<-TEXTO
#**logo_orpan**
#++fecha_reporte++

#La presente es para informales que en fecha ++fecha_gaceta++ se ha publicado la Gaceta Oficial de Bolivia Nº ++numero_gaceta++ correspondiente a las solicitudes de registro de signos distintivos presentados ante el Servicio Nacional de Propiedad Intelectual (SENAPI) durante los meses y trámites subsanados de meses anteriores.

#En la mencionada Gaceta se han publicado las siguientes solicitudes de registro solicitadas a nombre del <b>++titulares++</b>:

#**mini_ficha**
#
#El plazo para que terceros interpongan oposición contra las mencionadas solicitudes vence el dia ++fecha_vencimiento++. La fecha límite es común a todas las solicitudes que se publicaron en esta Gaceta.

#Les informaremos cualquier novedad con relación a las solicitudes arriba mencionadas.

Aprovechamos para enviarlas nuestros más cordiales saludos,
    TEXTO

        text_en =<<-TEXTO
**logo_orpan**
++fecha_reporte++

Dear Sirs:

This is to inform you that on ++fecha_gaceta++, the Bolivian Official Gazzette issue ++numero_gaceta++ has been published. This Gazzette is refered to trademark applications filed before the Bolivian Trademark Office (SENAPI) during (MESES), as well as previously filed applications that encountered formal observations.

In this issue the following trademark applications have been published in the name of ++titulares++:

**mini_ficha**

The deadline to file oppositions against the above mentioned application espires on ++fecha_vencimiento++.

We will keep you informed regarding the developments of these applications.

Kindest regards
    TEXTO

    Reporte.all(:conditions => {:clave => "lista_publicacion"}).each{|r| r.destroy}
    
    Reporte.create(:texto_es => text_es, :texto_en => text_en, :nombre_clase => "CruceReport", :clave => "lista_publicacion")
  end

  def self.down
    Reporte.all(:conditions => {:clave => "lista_publicacion"}).each{|r| r.destroy}
  end
end
