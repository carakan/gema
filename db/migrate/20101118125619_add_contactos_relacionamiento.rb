class AddContactosRelacionamiento < ActiveRecord::Migration
  def self.up
    add_column :contactos, :relacionamiento, :string
  end

  def self.down
    remove_column :contactos, :relacionamiento
  end
end
