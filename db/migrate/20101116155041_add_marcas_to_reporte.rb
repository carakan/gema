class AddMarcasToReporte < ActiveRecord::Migration
  def self.up
    change_table :reporte_marcas do |t|
      t.text :marca_ids_serial
      t.integer :marca_foranea_id
    end
  end

  def self.down
    change_table :reporte_marcas do |t|
      t.remove :marca_ids_serial, :marca_foranea_id
    end
  end
end
