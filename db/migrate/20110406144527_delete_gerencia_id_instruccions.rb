class DeleteGerenciaIdInstruccions < ActiveRecord::Migration
  def self.up
    drop_table :instruccions
    create_table :instruccions do |t|
      t.integer :area_id, :proyecto_id, :referencia_email
      t.timestamps
    end
  end

  def self.down
    create_table :instruccions do |t|
      t.integer :area_id, :proyecto_id, :referencia_email
      t.timestamps
    end
    drop_table :instruccions
  end
end
