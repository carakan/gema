class CreateUsuarios < ActiveRecord::Migration
  def self.up
    create_table :usuarios do |t|
      t.string :nombre
      t.string :login, :limit => 16
      t.string :email
      t.string :password, :limit => 40
      t.string :password_salt, :limit => 32 
      t.timestamps
    end
  end

  def self.down
    drop_table :usuarios
  end
end
