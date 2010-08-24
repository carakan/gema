class MarcasRepresentantes < ActiveRecord::Migration
  def self.up
    create_table :marcas_representantes do |t|
      t.integer :marca_id
      t.integer :representable_id
      t.string :representable_type, :limit => 20 # Indica si es que la relacion es de tipo agente o titular
    end

    #add_index :marcas_representantes, [:marca_id, :representante_id], :unique => true
    add_index :marcas_representantes, :marca_id
    add_index :marcas_representantes, :representable_id
    add_index :marcas_representantes, :representable_type
  end

  def self.down
    drop_table :marcas_representantes
  end
end
