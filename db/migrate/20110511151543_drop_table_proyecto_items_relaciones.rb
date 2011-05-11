class DropTableProyectoItemsRelaciones < ActiveRecord::Migration
  def self.up
    drop_table :proyecto_items_relaciones
  end

  def self.down
    create_table :proyecto_items_relaciones do |t|
      t.integer :item_id
      t.integer :proyecto_item_id
      t.float :monto

      t.timestamps
    end
  end
end
