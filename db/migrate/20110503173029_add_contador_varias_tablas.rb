class AddContadorVariasTablas < ActiveRecord::Migration
  def self.up
    add_column :proyecto_items, :contador, :integer
    add_column :instruccions, :contador, :integer
    add_column :instruccion_detalles, :contador, :integer
  end

  def self.down
    remove_column :proyecto_items, :contador
    remove_column :instruccions, :contador
    remove_column :instruccion_detalles, :contador
  end
end
