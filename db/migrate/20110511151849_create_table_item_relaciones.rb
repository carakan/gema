class CreateTableItemRelaciones < ActiveRecord::Migration
  def self.up
    create_table :items_relaciones do |t|
      t.integer :item_id
      t.integer :proyecto_item_id
      t.float :monto

      t.timestamps
    end
  end

  def self.down
    drop_table :items_relaciones
  end
end
