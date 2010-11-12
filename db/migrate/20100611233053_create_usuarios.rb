class CreateUsuarios < ActiveRecord::Migration
  def self.up
    create_table :usuarios do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      t.string :nombre
      t.string :login, :limit => 16

      t.timestamps
    end
    add_index :usuarios, :login,                :unique => true
    add_index :usuarios, :email,                :unique => true
    add_index :usuarios, :reset_password_token, :unique => true
  end

  def self.down
    drop_table :usuarios
  end
end
