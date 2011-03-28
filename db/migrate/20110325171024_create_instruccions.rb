class CreateInstruccions < ActiveRecord::Migration
  def self.up
    create_table :instruccions do |t|
      t.integer :proyecto_id
      t.integer :gerencia_id
      t.integer :referencia_email
      t.timestamps
    end
  end

  def self.down
    drop_table :instruccions
  end
end
