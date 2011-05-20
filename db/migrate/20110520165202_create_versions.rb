class CreateVersions < ActiveRecord::Migration
  def self.up
    #    create_table :versions do |t|
    #      t.string   :item_type, :null => false
    #      t.integer  :item_id,   :null => false
    #      t.string   :event,     :null => false
    #      t.string   :whodunnit
    #      t.text     :object
    #      t.datetime :created_at
    #    end
    #    add_index :versions, [:item_type, :item_id]
    
    
    #remove_column :marcas, :cambios
    #remove_column :marcas, :errores_manual
    #remove_column :marcas, :anterior
    puts "Iniciando la tarea!"
    cont = 1
    Marca.all(:conditions => {:parent_id => 0}).each do |marca|
      backup = marca.clone
      first_time = true
      marca.historial.each do |version|
        marca.attributes = version.attributes
        if first_time
          Marca.paper_trail_off
          marca.save(false)
          Marca.paper_trail_on
          first_time = false
        else
          marca.save(false)
        end
        version.delete
      end
      marca.attributes = backup.attributes
      marca.save(false)
      
      if cont % 1000 == 0
        puts "Se procesaron #{cont} registros"
      end
      cont += 1
    end
  end

  def self.down
    remove_index :versions, [:item_type, :item_id]
    drop_table :versions
  end
end