class AddRepresentantesDivisionPostal < ActiveRecord::Migration
  def self.up
    add_column :representantes, :division, :string
    add_column :representantes, :postal, :string
    add_column :representantes, :gerencia, :string
  end

  def self.down
    remove_column :representantes, :division
    remove_column :representantes, :postal
    remove_column :representantes, :gerencia
  end
end
