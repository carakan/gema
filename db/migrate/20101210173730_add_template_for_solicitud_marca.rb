# encoding: utf-8
class AddTemplateForSolicitudMarca < ActiveRecord::Migration
  def self.up
    text_es =<<-TEXTO
**logo_orpan**
++fecha_reporte++

Estimados señores,


Del servicio de información de nuevas solicitudesde registro de signos distintivos habilitado por la Oficina de Marcas de Bolivia (SENAPI) habilitado a través de su pagina web, hemos podido identificar la presentacion del siguiente signo distintivo a nombre de  ++titulares++:

**mini_ficha**

Nuestro sistema de vigilancia ha identificado que este signo es similar a lo(s) siguiente(s) signo(s) distintivo (s) a nombre del TITULAR CLIENTE DE ORPAN:

**tabla_reporte**

**analisis**

Si bien el signo identificado no ha sido aún publicado, cumplimos en darles esta información con la finalidad de tenerlos al tanto de la existencia de esta solicitud. Es posible que la misma sufra modificaciones hasta el momento de su publicación. Si ustedes tienen interés en recibir un informe en momento que esta solicitud se publique, aguardaremos sus instrucciones en este sentido.

Cordiales saludos,
    TEXTO

        text_en =<<-TEXTO
**logo_orpan**
++fecha_reporte++

Dear Sirs:

According to The Bolivian Trademark Office's online information service the following trademark application has been filed by ++titulares++:

**mini_ficha**

Our watch service system has show that this application is similar to the following trademark(s):

**tabla_reporte**

**analisis**

Since this application has not been officially published yet, it could be subject to formal observations or modifications. In the event this trademark is published please let us know it you are interested in receiving a report from us in order to consider the possible filing of an opposition.

Kindest regards,
    TEXTO

    Reporte.all(:conditions => {:clave => "solicitud_marca"}).each{|r| r.destroy}

    Reporte.create(:texto_es => text_es, :texto_en => text_en, :nombre_clase => "CruceReport", :clave => "solicitud_marca")
  end

  def self.down
    Reporte.all(:conditions => {:clave => "solicitud_marca"}).each{|r| r.destroy}
  end
end
