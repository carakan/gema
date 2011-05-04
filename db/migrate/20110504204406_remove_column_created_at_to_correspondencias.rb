class RemoveColumnCreatedAtToCorrespondencias < ActiveRecord::Migration
  def self.up
    remove_column :correspondencias, :created_at
    remove_column :correspondencias, :updated_at
  end

  def self.down
    add_column :correspondencias, :updated_at, :datetime
    add_column :correspondencias, :created_at, :datetime
  end
end
