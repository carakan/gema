class AddColumnEstadoToItemsRelacion < ActiveRecord::Migration
  def self.up
    add_column :items_relaciones, :estado, :string,  :limit => 20
    add_column :items_relaciones, :transaction_id, :integer
  end

  def self.down
    remove_column :items_relaciones, :transaction_id
    remove_column :items_relaciones, :estado
  end
end
