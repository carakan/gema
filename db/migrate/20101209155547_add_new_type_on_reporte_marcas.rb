class AddNewTypeOnReporteMarcas < ActiveRecord::Migration
  def self.up
    change_table :reporte_marcas do |t|
      t.integer :tipo_reporte
    end
    ReporteMarca.all.each do |record|
      if record.importacion_id
        record.update_attribute(:tipo_reporte, 1)
      else
        record.update_attribute(:tipo_reporte, 0)
      end
    end
  end

  def self.down
    change_table :reporte_marcas do |t|
      t.remove :tipo_reporte
    end
  end
end
