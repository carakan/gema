class RemoveColumnItemIdToProyectoItems < ActiveRecord::Migration
  def self.up
    remove_column :proyecto_items, :item_id
  end

  def self.down
    add_column :proyecto_items, :item_id, :integer
  end
end
