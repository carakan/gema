class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions, :force => true do |t|
      t.integer :rol_id
      t.string :controller, :limit => 150
      t.string :actions

      t.timestamps
    end
  end

  def self.down
    drop_table :permisos
  end
end
