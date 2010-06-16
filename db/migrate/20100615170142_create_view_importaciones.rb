class CreateViewImportaciones < ActiveRecord::Migration
  def self.up
    sql = "CREATE VIEW view_importaciones AS
      SELECT fecha_importacion, COUNT(DISTINCT(total)) - 1 AS total, COUNT(DISTINCT(errores)) -1 AS errores, estado FROM
        (
          SELECT fecha_importacion, id AS total, 0 as errores, estado FROM marcas 
          UNION
          SELECT fecha_importacion, 0 AS total, id as errores, estado FROM marcas WHERE valido = 'f'
        ) AS importaciones GROUP BY fecha_importacion ORDER BY fecha_importacion"

    execute(sql)
  end

  def self.down
    execute("DROP VIEW view_importaciones")
  end
end
