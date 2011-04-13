class CreateProyecto::Instruccions < ActiveRecord::Migration
  def self.up
    create_table :proyecto/instruccions do |t|
      t.integer :codigo
      t.integer :proyecto_id
      t.int :gerencia_id
      t.int :referencia_email
      t.timestamps
    end
  end

  def self.down
    drop_table :proyecto/instruccions
  end
end
