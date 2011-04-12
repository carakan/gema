# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110406144527) do

  create_table "adjuntos", :force => true do |t|
    t.string   "nombre"
    t.integer  "adjuntable_id"
    t.string   "adjuntable_type"
    t.string   "archivo_file_name"
    t.integer  "archivo_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adjuntos", ["adjuntable_id"], :name => "index_adjuntos_on_adjuntable_id"
  add_index "adjuntos", ["adjuntable_type"], :name => "index_adjuntos_on_adjuntable_type"

  create_table "areas", :force => true do |t|
    t.string   "nombre"
    t.string   "sigla"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clases", :force => true do |t|
    t.string   "nombre"
    t.integer  "codigo",      :null => false
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consulta_detalles", :force => true do |t|
    t.integer  "consulta_id"
    t.integer  "marca_id"
    t.integer  "tipo_de_busqueda"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consultas", :force => true do |t|
    t.integer  "marca_id"
    t.integer  "usuario_id"
    t.string   "busqueda"
    t.string   "parametros",       :limit => 400
    t.string   "comentario",       :limit => 800
    t.string   "marca_ids_serial",                :default => "[]"
    t.integer  "importacion_id",                  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "descartada",                      :default => false
    t.integer  "representante_id"
  end

  add_index "consultas", ["representante_id"], :name => "index_consultas_on_representante_id"

  create_table "contactos", :force => true do |t|
    t.integer  "representante_id"
    t.string   "nombre"
    t.string   "cargo"
    t.string   "telefono"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "relacionamiento"
  end

  add_index "contactos", ["representante_id"], :name => "index_contactos_on_representante_id"

  create_table "correspondencias", :force => true do |t|
    t.integer  "proyecto_id"
    t.boolean  "tipo"
    t.text     "contenido"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "importaciones", :force => true do |t|
    t.boolean  "completa"
    t.string   "publicacion",        :limit => 30
    t.date     "publicacion_fecha"
    t.date     "fecha_importacion"
    t.date     "fecha_limite"
    t.date     "fecha_limite_orpan"
    t.string   "tipo"
    t.string   "archivo_file_name"
    t.integer  "archivo_file_size"
    t.integer  "cruces_pendientes",                :default => -1
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instruccion_detalles", :force => true do |t|
    t.integer  "instruccion_id"
    t.integer  "usuario_id"
    t.string   "tarea"
    t.datetime "fecha_limite"
    t.string   "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instruccion_detalles_item_cobros", :id => false, :force => true do |t|
    t.integer "instruccion_detalle_id"
    t.integer "proyecto_item_id"
  end

  create_table "instruccions", :force => true do |t|
    t.integer  "area_id"
    t.integer  "proyecto_id"
    t.integer  "referencia_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_cobros_marcas", :id => false, :force => true do |t|
    t.integer "proyecto_item_id"
    t.integer "marca_id"
  end

  create_table "items", :force => true do |t|
    t.integer  "categoria_id"
    t.string   "sigla"
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "marca_estados", :force => true do |t|
    t.string   "nombre"
    t.string   "abreviacion", :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "modulo"
  end

  create_table "marcas", :force => true do |t|
    t.integer  "parent_id",                                   :default => 0
    t.integer  "usuario_id",                  :limit => 2,    :default => 1
    t.string   "nombre",                                      :default => ""
    t.boolean  "propia",                                      :default => false
    t.boolean  "activa",                                      :default => true
    t.integer  "marca_estado_id",             :limit => 2,    :default => 104
    t.integer  "tipo_signo_id",               :limit => 2,    :default => 104
    t.integer  "tipo_marca_id",               :limit => 2,    :default => 104
    t.integer  "clase_id",                    :limit => 2,    :default => 104
    t.text     "productos"
    t.string   "numero_solicitud",            :limit => 15,   :default => ""
    t.date     "fecha_solicitud"
    t.string   "numero_publicacion",          :limit => 15,   :default => ""
    t.date     "fecha_publicacion"
    t.string   "numero_registro",             :limit => 15,   :default => ""
    t.date     "fecha_registro"
    t.string   "numero_solicitud_renovacion", :limit => 15,   :default => ""
    t.date     "fecha_solicitud_renovacion"
    t.string   "numero_renovacion",           :limit => 15,   :default => ""
    t.date     "fecha_renovacion"
    t.string   "instruccion",                 :limit => 128,  :default => ""
    t.string   "via_instruccion",             :limit => 128,  :default => ""
    t.date     "fecha_instruccion"
    t.string   "numero_gaceta",               :limit => 10,   :default => ""
    t.string   "representante_empresarial",   :limit => 512,  :default => ""
    t.string   "apoderado",                   :limit => 512,  :default => ""
    t.string   "observaciones",               :limit => 2056, :default => ""
    t.integer  "fila"
    t.boolean  "importado",                                   :default => false
    t.integer  "importacion_id"
    t.date     "fecha_importacion"
    t.boolean  "valido"
    t.string   "cambios",                                     :default => "[]"
    t.string   "archivo_adjunto",                             :default => ""
    t.string   "descripcion_imagen",                          :default => ""
    t.boolean  "anterior",                                    :default => false
    t.string   "nombre_minusculas",                           :default => ""
    t.string   "agente_ids_serial"
    t.string   "titular_ids_serial"
    t.string   "errores",                     :limit => 700
    t.string   "errores_manual",              :limit => 500
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "domicilio_titular",           :limit => 512,  :default => ""
    t.integer  "pais_prioridad_id"
    t.date     "fecha_prioridad"
    t.integer  "numero_prioridad"
    t.integer  "lema_marca_id"
    t.string   "estado",                                      :default => ""
  end

  add_index "marcas", ["activa"], :name => "index_marcas_on_activa"
  add_index "marcas", ["clase_id"], :name => "index_marcas_on_clase_id"
  add_index "marcas", ["fecha_importacion"], :name => "index_marcas_on_fecha_importacion"
  add_index "marcas", ["importacion_id"], :name => "index_marcas_on_importacion_id"
  add_index "marcas", ["importado"], :name => "index_marcas_on_importado"
  add_index "marcas", ["nombre_minusculas"], :name => "index_marcas_on_nombre_minusculas"
  add_index "marcas", ["numero_publicacion"], :name => "numero_publicacion"
  add_index "marcas", ["numero_registro"], :name => "numero_registro"
  add_index "marcas", ["numero_renovacion"], :name => "numero_renovacion"
  add_index "marcas", ["numero_solicitud"], :name => "numero_solicitud"
  add_index "marcas", ["parent_id"], :name => "index_marcas_on_parent_id"
  add_index "marcas", ["propia"], :name => "index_marcas_on_propia"
  add_index "marcas", ["tipo_marca_id"], :name => "index_marcas_on_tipo_marca_id"
  add_index "marcas", ["tipo_signo_id"], :name => "index_marcas_on_tipo_signo_id"
  add_index "marcas", ["usuario_id"], :name => "index_marcas_on_usuario_id"

  create_table "marcas_agentes", :id => false, :force => true do |t|
    t.integer "marca_id"
    t.integer "agente_id"
  end

  add_index "marcas_agentes", ["agente_id"], :name => "index_marcas_agentes_on_agente_id"
  add_index "marcas_agentes", ["marca_id", "agente_id"], :name => "index_marcas_agentes_on_marca_id_and_agente_id", :unique => true
  add_index "marcas_agentes", ["marca_id"], :name => "index_marcas_agentes_on_marca_id"

  create_table "marcas_titulares", :id => false, :force => true do |t|
    t.integer "marca_id"
    t.integer "titular_id"
  end

  add_index "marcas_titulares", ["marca_id", "titular_id"], :name => "index_marcas_titulares_on_marca_id_and_titular_id", :unique => true
  add_index "marcas_titulares", ["marca_id"], :name => "index_marcas_titulares_on_marca_id"
  add_index "marcas_titulares", ["titular_id"], :name => "index_marcas_titulares_on_titular_id"

  create_table "paises", :force => true do |t|
    t.string   "nombre",     :limit => 30
    t.string   "codigo",     :limit => 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "rol_id"
    t.string   "controller", :limit => 150
    t.string   "actions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "postable_id"
    t.string   "postable_type"
    t.integer  "usuario_id"
    t.string   "categoria",                     :default => "\"\"", :null => false
    t.string   "titulo"
    t.string   "comentario",    :limit => 2058
    t.integer  "accesso"
    t.boolean  "adjuntos",                      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["postable_id"], :name => "index_posts_on_postable_id"
  add_index "posts", ["postable_type"], :name => "index_posts_on_postable_type"

  create_table "proyecto_items", :force => true do |t|
    t.integer  "proyecto_id"
    t.string   "descripcion"
    t.string   "estado"
    t.string   "referencia_cliente"
    t.string   "referencia_cliente_cobranza"
    t.date     "fecha_limite"
    t.float    "honorarios"
    t.float    "gastos_adminitrativos"
    t.float    "monto"
    t.date     "fecha_solicitud"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "tipo"
    t.integer  "item_id"
  end

  create_table "proyectos", :force => true do |t|
    t.integer  "contacto_id"
    t.integer  "representante_id"
    t.integer  "area_id"
    t.string   "titulo"
    t.string   "referencia_cliente"
    t.string   "prioridad"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proyectos_contactos", :id => false, :force => true do |t|
    t.integer "proyecto_id"
    t.integer "contacto_id"
  end

  create_table "reporte_marca_detalles", :force => true do |t|
    t.integer  "reporte_marca_id"
    t.integer  "marca_id"
    t.integer  "marca_foranea_id"
    t.string   "busqueda"
    t.string   "comentario",       :limit => 800
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reporte_marca_detalles", ["marca_id"], :name => "index_reporte_marca_detalles_on_marca_id"
  add_index "reporte_marca_detalles", ["reporte_marca_id"], :name => "index_reporte_marca_detalles_on_reporte_marca_id"

  create_table "reporte_marcas", :force => true do |t|
    t.integer  "representante_id"
    t.string   "representante_type"
    t.integer  "importacion_id"
    t.string   "carta",              :limit => 500
    t.string   "reporte_pdf"
    t.string   "idioma",             :limit => 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "consulta_id"
    t.string   "busqueda"
    t.text     "marca_ids_serial"
    t.integer  "marca_foranea_id"
    t.integer  "tipo_reporte"
  end

  add_index "reporte_marcas", ["representante_id"], :name => "index_reporte_marcas_on_representante_id"
  add_index "reporte_marcas", ["representante_type"], :name => "index_reporte_marcas_on_representante_type"

  create_table "reportes", :force => true do |t|
    t.text     "texto_en"
    t.text     "texto_es"
    t.string   "nombre_clase"
    t.string   "clave",        :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "representantes", :force => true do |t|
    t.integer  "pais_id"
    t.string   "nombre"
    t.string   "email"
    t.string   "direccion"
    t.string   "telefono"
    t.string   "movil"
    t.string   "fax"
    t.string   "pagina_web"
    t.string   "type"
    t.boolean  "valido"
    t.boolean  "cliente",                  :default => false
    t.string   "pais_codigo", :limit => 4
    t.string   "pais_nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "division"
    t.string   "postal"
    t.string   "gerencia"
  end

  add_index "representantes", ["nombre"], :name => "index_representantes_on_nombre"
  add_index "representantes", ["pais_id"], :name => "index_representantes_on_pais_id"

  create_table "roles", :force => true do |t|
    t.string   "name",        :limit => 100
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_marcas", :force => true do |t|
    t.string   "nombre",      :limit => 100
    t.string   "sigla",       :limit => 5
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_signos", :force => true do |t|
    t.string   "sigla",      :limit => 10
    t.string   "nombre",     :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usuarios", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "nombre"
    t.string   "login",                :limit => 16
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rol_id"
    t.integer  "area_id"
  end

  add_index "usuarios", ["email"], :name => "index_usuarios_on_email", :unique => true
  add_index "usuarios", ["login"], :name => "index_usuarios_on_login", :unique => true
  add_index "usuarios", ["reset_password_token"], :name => "index_usuarios_on_reset_password_token", :unique => true

  create_table "v_marcas_atomizadas", :id => false, :force => true do |t|
    t.integer  "id",                                            :default => 0,     :null => false
    t.integer  "parent_id",                                     :default => 0
    t.integer  "usuario_id",                    :limit => 2,    :default => 1
    t.string   "nombre",                                        :default => ""
    t.boolean  "propia",                                        :default => false
    t.boolean  "activa",                                        :default => true
    t.integer  "marca_estado_id",               :limit => 2,    :default => 104
    t.integer  "tipo_signo_id",                 :limit => 2,    :default => 104
    t.integer  "tipo_marca_id",                 :limit => 2,    :default => 104
    t.integer  "clase_id",                      :limit => 2,    :default => 104
    t.text     "productos"
    t.integer  "numero_solicitud_n",            :limit => 8
    t.integer  "numero_solicitud_a",            :limit => 8
    t.date     "fecha_solicitud"
    t.string   "numero_publicacion",            :limit => 15,   :default => ""
    t.date     "fecha_publicacion"
    t.integer  "numero_registro_n",             :limit => 8
    t.date     "fecha_registro"
    t.integer  "numero_solicitud_renovacion_n", :limit => 8
    t.integer  "numero_solicitud_renovacion_a", :limit => 8
    t.date     "fecha_solicitud_renovacion"
    t.integer  "numero_renovacion_n",           :limit => 8
    t.date     "fecha_renovacion"
    t.string   "instruccion",                   :limit => 128,  :default => ""
    t.string   "via_instruccion",               :limit => 128,  :default => ""
    t.date     "fecha_instruccion"
    t.string   "numero_gaceta",                 :limit => 10,   :default => ""
    t.string   "representante_empresarial",     :limit => 512,  :default => ""
    t.string   "apoderado",                     :limit => 512,  :default => ""
    t.string   "observaciones",                 :limit => 2056, :default => ""
    t.integer  "fila"
    t.boolean  "importado",                                     :default => false
    t.integer  "importacion_id"
    t.date     "fecha_importacion"
    t.boolean  "valido"
    t.string   "cambios",                                       :default => "[]"
    t.string   "archivo_adjunto",                               :default => ""
    t.string   "descripcion_imagen",                            :default => ""
    t.boolean  "anterior",                                      :default => false
    t.string   "nombre_minusculas",                             :default => ""
    t.string   "agente_ids_serial"
    t.string   "titular_ids_serial"
    t.string   "errores",                       :limit => 700
    t.string   "errores_manual",                :limit => 500
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
