class AddProyectoItemItemId < ActiveRecord::Migration
  def self.up
    add_column :proyecto_items, :item_id, :integer
  end

  def self.down
    remove_column :proyecto_items, :item_id
  end
end
