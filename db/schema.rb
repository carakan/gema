# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100527195237) do

  create_table "clases", :force => true do |t|
    t.string   "nombre"
    t.integer  "codigo",      :null => false
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "marcas", :force => true do |t|
    t.integer  "agente_id"
    t.integer  "titular_id"
    t.integer  "tipo_marca_id"
    t.integer  "clase_id"
    t.integer  "usuario_id"
    t.integer  "marca_id"
    t.string   "sm",                :limit => 40
    t.string   "nombre"
    t.string   "numero_registro"
    t.string   "numero_renovacion"
    t.string   "productos"
    t.boolean  "activo"
    t.string   "estado"
    t.date     "estado_fecha"
    t.string   "estado_serial"
    t.string   "publicacion"
    t.string   "gaceta"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marcas", ["agente_id"], :name => "index_marcas_on_agente_id"
  add_index "marcas", ["clase_id"], :name => "index_marcas_on_clase_id"
  add_index "marcas", ["marca_id"], :name => "index_marcas_on_marca_id"
  add_index "marcas", ["tipo_marca_id"], :name => "index_marcas_on_tipo_marca_id"
  add_index "marcas", ["titular_id"], :name => "index_marcas_on_titular_id"
  add_index "marcas", ["usuario_id"], :name => "index_marcas_on_usuario_id"

end
