class CreateConsultas < ActiveRecord::Migration
  def self.up
    create_table :consultas do |t|
      t.integer :marca_id
      t.integer :usuario_id
      t.string :busqueda
      t.string :parametros, :limit => 400
      t.string :comentario, :limit => 400
      t.string :reporte
      t.integer :importacion_id, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :consultas
  end
end
