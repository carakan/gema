class AddCounterOnEmails < ActiveRecord::Migration
  def self.up
    add_column :correspondencias, :contador, :integer, :default => 0
  end

  def self.down
    remove_column :correspondencias, :contador
  end
end
