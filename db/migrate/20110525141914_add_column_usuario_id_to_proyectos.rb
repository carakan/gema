class AddColumnUsuarioIdToProyectos < ActiveRecord::Migration
  def self.up
    add_column :proyectos, :usuario_id, :integer 
  end

  def self.down
    remove_column :proyectos, :usuario_id 
  end
end
