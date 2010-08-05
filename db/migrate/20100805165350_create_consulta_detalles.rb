class CreateConsultaDetalles < ActiveRecord::Migration
  def self.up
    create_table :consulta_detalles do |t|
      t.integer :consulta_id
      t.integer :marca_id
      t.string :comentario, :limit => 800
      t.integer :tipo

      t.timestamps
    end
  end

  def self.down
    drop_table :consulta_detalles
  end
end
