class AddRelationsOnReporteMarca < ActiveRecord::Migration
  def self.up
    change_table :reporte_marcas do |t|
      t.integer :consulta_id
      t.string :busqueda
    end
  end

  def self.down
    change_table :reporte_marcas do |t|
      t.remove :consulta_id, :busqueda
    end
  end
end
