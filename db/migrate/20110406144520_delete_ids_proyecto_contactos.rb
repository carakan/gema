class DeleteIdsProyectoContactos < ActiveRecord::Migration
  def self.up
    drop_table :proyecto_contactos
    create_table :proyectos_contactos, :id => false do |t|
      t.integer :proyecto_id, :contacto_id
    end
  end

  def self.down
    create_table :proyecto_contactos do |t|
      t.integer :proyecto_id, :representante_id, :contacto_id
      t.timestamps
    end
    drop_table :proyectos_contactos
  end
end
