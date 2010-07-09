class AgentesMarcas < ActiveRecord::Migration
  def self.up
    create_table :agentes_marcas, :id => false do |t|
      t.integer :agente_id
      t.integer :marca_id
    end

    add_index :agentes_marcas, [:agente_id, :marca_id], :unique => true
    add_index :agentes_marcas, :agente_id
    add_index :agentes_marcas, :marca_id

  end

  def self.down
    drop_table :agentes_marcas
  end
end
