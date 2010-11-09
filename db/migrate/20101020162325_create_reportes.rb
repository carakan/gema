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

Denominación:     {{palabra_busqueda}}
Clase (s) Int:    {{clase_en_busqueda}}
Fecha:    {{fecha_reporte}}

Resultados

**tabla_reporte**

**analisis**
    RTM

    texto_busqueda_en =<<-RTM
**logo_orpan**

<b>SEARCH REPORT</b>

Word:     {{palabra_busqueda}}
Int. Class (es):    {{clase_en_busqueda}}
Date (dd/mm/yy):    {{fecha_reporte}}

Results

**tabla_reporte**

**analisis**
    RTM

    texto_cruce_es =<<-RTM
**logo_orpan**
**fecha_reporte**

Estimados Señores:

La presente es para informarles que en la edicion Nro

Cruce de datos, 

**mini_ficha**

**tabla_reporte**
      RTM

      texto_cruce_en =<<-RTM
**logo_orpan**
**fecha_reporte**

Dear Sirs:

On  , the following

**mini_ficha**

**tabla_reporte**
      RTM

    Reporte.create(:texto_es => texto_busqueda_es, :texto_en => texto_busqueda_en, :nombre_clase => "BusquedaReport", :clave => "busqueda_report")
    Reporte.create(:texto_es => texto_cruce_es, :texto_en => texto_cruce_en, :nombre_clase => "CruceReport", :clave => "cruce_report")
  end

  def self.down
    drop_table :reportes
  end
end
