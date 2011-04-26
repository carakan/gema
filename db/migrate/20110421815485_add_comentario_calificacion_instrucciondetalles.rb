class AddComentarioCalificacionInstrucciondetalles < ActiveRecord::Migration
  def self.up
    remove_column :instruccion_detalles, :estado
    add_column :instruccion_detalles, :comentario_evaluacion, :string
    add_column :instruccion_detalles, :calificacion, :integer
  end

   def self.down
    add_column :instruccion_detalles, :estado, :string
    remove_column :instruccion_detalles, :comentario_evaluacion
    remove_column :instruccion_detalles, :calificacion
  end
end
