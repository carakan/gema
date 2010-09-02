class CreateReporteMarcas < ActiveRecord::Migration
  def self.up
    create_table :reporte_marcas do |t|
      t.integer :representante_id
      t.string :representante_type
      t.integer :importacion_id
      t.string :reporte_pdf

      t.timestamps
    end
    add_index :reporte_marcas, :representante_id
    add_index :reporte_marcas, :representante_type
  end

  def self.down
    drop_table :reporte_marcas
  end
end
