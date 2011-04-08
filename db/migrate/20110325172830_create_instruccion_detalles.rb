class CreateInstruccionDetalles < ActiveRecord::Migration
  def self.up
    create_table :instruccion_detalles do |t|
      t.integer :instruccion_id
      t.integer :usuario_id
      t.string :tarea
      t.datetime :fecha_limite
      t.string :estado
      t.timestamps
    end
  end

  def self.down
    drop_table :instruccion_detalles
  end
end
