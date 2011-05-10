class AddColumnAncestryToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :ancestry, :string
    add_index :items, :ancestry
  end

  def self.down
    remove_column :items, :ancestry
    remove_index :items, :ancestry
  end
end

