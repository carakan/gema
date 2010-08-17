class CreatePermisos < ActiveRecord::Migration
  def self.up
    create_table :permisos, :force => true do |t|
      t.integer :rol_id
      t.string :controlador, :limit => 150
      t.string :acciones

      t.timestamps
    end
  end

  def self.down
    drop_table :permisos
  end
end
