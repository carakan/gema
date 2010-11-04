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
**logoOrpan**
**fechaReporte**

Datos de la Busqueda simple

**tablaReporte**
    RTM

    texto_busqueda_en =<<-RTM
**logoOrpan**
**fechaReporte**

Data for simple search

**tablaReporte**
    RTM

    texto_cruce_es =<<-RTM
**logoOrpan**
**fechaReporte**

Estimados Señores:

La presente es para informarles que en la edicion Nro

Cruce de datos, 

**miniFicha**

**tablaReporte**
      RTM

      texto_cruce_en =<<-RTM
**logoOrpan**
**fechaReporte**

Dear Sirs:

On  , the following

**miniFicha**

**tablaReporte**
      RTM

    Reporte.create(:texto_es => texto_busqueda_es, :texto_en => texto_busqueda_en, :nombre_clase => "BusquedaReport", :clave => "busqueda_report")
    Reporte.create(:texto_es => texto_cruce_es, :texto_en => texto_cruce_en, :nombre_clase => "CruceReport", :clave => "cruce_report")
  end

  def self.down
    drop_table :reportes
  end
end
