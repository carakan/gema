class CreateMarcasAgentes < ActiveRecord::Migration
  def self.up
    create_table :marcas_agentes, :id => false do |t|
      t.integer :marca_id
      t.integer :agente_id
    end
    add_index :marcas_agentes, :marca_id
    add_index :marcas_agentes, :agente_id
    add_index :marcas_agentes, [ :marca_id, :agente_id ], :unique => true
  end

  def self.down
    drop_table :marcas_agentes
  end
end
