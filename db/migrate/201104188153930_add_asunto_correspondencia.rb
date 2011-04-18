class AddAsuntoCorrespondencia < ActiveRecord::Migration
  def self.up
    add_column :correspondencias, :asunto, :string
  end

   def self.down
    remove_column :correspondencias, :asunto
  end
end