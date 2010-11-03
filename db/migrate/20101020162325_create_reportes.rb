class CreateReportes < ActiveRecord::Migration
  def self.up
    create_table :reportes do |t|
      t.text :texto_en
      t.text :texto_es
      t.string :nombre_clase
      t.string :clave, :limit => 20
      t.timestamps
    end

    #Reporte.create(:texto_es =>"  **encabezado** La Paz xxxxxxx **tabla** blabla", :nombre_clase => "ReporteMarca")
  end

  def self.down
    drop_table :reportes
  end
end
