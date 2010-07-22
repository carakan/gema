class AddRepresentantePaisId < ActiveRecord::Migration
  def self.up
    add_column :representantes, :pais_id, :integer
    add_index :representantes, :pais_id
  end

  def self.down
    remove_column :representantes, :pais_id
  end
end
