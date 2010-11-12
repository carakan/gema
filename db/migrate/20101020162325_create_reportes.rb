# encoding: utf-8
class CreateReportes < ActiveRecord::Migration
  def self.up
    create_table :reportes do |t|
      t.text :texto_en
      t.text :texto_es
      t.string :nombre_clase
      t.string :clave, :limit => 20
      t.timestamps
    end

    texto_busqueda_es =<<-RTM
**logo_orpan**

<b>REPORTE DE BÚSQUEDA</b>

Denominación:     ++palabra_busqueda++
Clase (s) Int:    ++clase_en_busqueda++
Fecha:    ++fecha_reporte++

Resultados

**tabla_reporte**

**analisis**
    RTM

    texto_busqueda_en =<<-RTM
**logo_orpan**

<b>SEARCH REPORT</b>

Word:     ++palabra_busqueda++
Int. Class (es):    ++clase_en_busqueda++
Date (dd/mm/yy):    ++fecha_reporte++

Results

**tabla_reporte**

**analisis**
    RTM

    texto_cruce_es =<<-RTM
**logo_orpan**
++fecha_reporte++

Estimados señores:

La presente es para informarles que en la edicion Nro ++edicion_gaceta++ de la Gaceta Oficial de Bolivia Nro ++numero_gaceta++ puesta en circulación en fecha ++fecha_gaceta++ se ha publicado la siguiente solicitud de registro de signo distintivo

**mini_ficha**

que consideramos similar a la (s) siguientes marca (s) a nombre de <b>TITULAR</b>:

**tabla_reporte**

**analisis**

Estaremos atentos a sus instrucciones sobre el particular.

Cordiales saludos, 
      RTM

      texto_cruce_en =<<-RTM
**logo_orpan**
++fecha_reporte++

Dear Sirs:

On ++fecha_gaceta++, the following trademark application was published in the Bolivian Official Gazzette issue Nr. (número de la Gaceta) filed by TITULAR:

**mini_ficha**

Our watch service system has identified this application to be similar to the following trademark owned by TITULAR:

**tabla_reporte**

**analisis**

Yours faithfully,
      RTM

    Reporte.create(:texto_es => texto_busqueda_es, :texto_en => texto_busqueda_en, :nombre_clase => "BusquedaReport", :clave => "busqueda_report")
    Reporte.create(:texto_es => texto_cruce_es, :texto_en => texto_cruce_en, :nombre_clase => "CruceReport", :clave => "cruce_report")
  end

  def self.down
    drop_table :reportes
  end
end
