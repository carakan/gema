class CreateViewImportaciones < ActiveRecord::Migration
  def self.up
    # Todos
    sql = "CREATE VIEW view_importaciones_todos AS
    SELECT importacion_id, COUNT(*) AS total, 0 as errores, estado FROM marcas 
    WHERE parent_id = 0 AND importado = 1
    GROUP BY importacion_id"
    execute(sql)
    # Errores
    sql2 = Marca.send(:construct_finder_sql, 
                      :select => "importacion_id, 0 AS total, COUNT(*) AS errores, estado",
                      :conditions => ["valido = ? AND importado = ?", false, true], # No es necesario :parent_id => 0, por que hay un default scope
                      :group => "marcas.importacion_id"
                     )
    sql = "CREATE VIEW view_importaciones_errores AS #{sql2}"
    execute(sql)
    # Vista final
    sql = "CREATE VIEW view_importaciones AS
    SELECT * FROM view_importaciones_todos UNION SELECT * FROM view_importaciones_errores"
    execute(sql)
  end

  def self.down
    execute("DROP VIEW view_importaciones")
    execute("DROP VIEW view_importaciones_todos")
    execute("DROP VIEW view_importaciones_errores")
  end
end
