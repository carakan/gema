class AddTituloEnProyectos < ActiveRecord::Migration
  def self.up
    add_column :proyectos, :titulo_en, :string, :default => ""
  end

  def self.down
    add_column :proyectos, :titulo_en
  end
end
