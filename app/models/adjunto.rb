
class Adjunto < ActiveRecord::Base
  after_save :set_marca_archivo
  #after_save :set_tipo

  belongs_to :adjuntable, :polymorphic => true

  has_attached_file :archivo, :styles => { :mini => "100x100>" },
    :path => ":rails_root/public/system/:rails_env/adjuntos/:id_partition/:style-:filename",
    :url => "/system/:rails_env/adjuntos/:id_partition/:style-:filename"
  before_post_process :image?

  # Indica si el tipo de adjunto es imagen
  def image?
    ['.png', '.jpg', '.gif', '.bmp'].include? File.extname( self.archivo.original_filename.downcase )
  end

  # Indica el tipo de archivo que es el adjunto
  def tipo
    File.extname( archivo.url ).downcase.gsub('.', '')
  end

  # indica la cantidad de bytes en bytes, Kb, MB
  def quota
    @regex = /^([0-9]+\.?[0-9]*?) (.*)/
    @sizes = { 'kilobyte' => 1024, 'megabyte' => 1048576, 'gigabyte' => 1073741824}
    m = self.quota.match(@regex)
    if @sizes.include? m[2].singularize
      self.quota = m[1].to_f*@sizes[m[2].singularize]
    end
  end

private

 # metodo que actualiza el archivo de la marca
  def set_marca_archivo
    if self.adjuntable_type == 'Marca'
      self.adjuntable.con_historico = false
      self.adjuntable.update_attribute( 'archivo_adjunto', self.archivo.url(:mini) )
    end
  end
end
