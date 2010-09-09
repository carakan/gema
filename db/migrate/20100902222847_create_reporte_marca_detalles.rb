class CreateReporteMarcaDetalles < ActiveRecord::Migration
  def self.up
    create_table :reporte_marca_detalles do |t|
      t.integer :reporte_marca_id
      t.integer :marca_id # marca propia
      t.integer :marca_foranea_id
      t.string :busqueda # En caso de que la busqueda sea con un texto y no sea cruce
      t.string :comentario, :limit => 800
      t.boolean :ignorada # indica si fue ignarada la marca para el reporte

      t.timestamps
    end
    add_index :reporte_marca_detalles, :reporte_marca_id
    add_index :reporte_marca_detalles, :marca_id
  end

  def self.down
    drop_table :reporte_marca_detalles
  end
end
