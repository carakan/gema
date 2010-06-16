class CreateViewImportaciones < ActiveRecord::Migration
  def self.up
    sql = "CREATE VIEW view_importaciones AS
      SELECT fecha_importacion, SUM(total) AS total, SUM(errores) AS errores, estado FROM
        (
          SELECT fecha_importacion, COUNT(*) AS total, 0 as errores, estado FROM marcas 
          UNION
          SELECT fecha_importacion, 0 AS total, COUNT(*) as errores, estado FROM marcas WHERE valido = 'f'
        ) AS importaciones GROUP BY fecha_importacion ORDER BY fecha_importacion"

    execute(sql)
  end

  def self.down
    excute("DROP VIEW viem_importaciones")
  end
end
