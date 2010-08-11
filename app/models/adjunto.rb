class Adjunto < ActiveRecord::Base
  before_save :set_marca_archivo

  belongs_to :adjuntable, :polymorphic => true

  has_attached_file :archivo, :styles => { :mini => "100x100>" },
    :path => ":rails_root/public/system/:rails_env/adjuntos/:id_partition/:style-:filename",
    :url => "/system/:rails_env/adjuntos/:id_partition/:style-:filename"
  before_post_process :image?

  def image?
    ['.png', '.jpg', '.gif', '.bmp'].include? File.extname( self.archivo.original_filename.downcase )
  end

  def tipo
    File.extname( archivo.url ).downcase.gsub('.', '')
  end

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
      adj = Adjunto.last(:conditions => {:adjuntable_type => self.adjuntable.class.to_s, :adjuntable_id => self.adjuntable.id} )
      m = Marca.historial(self.adjuntable.id, :limit => 1)
      img = adj.archivo.url(:mini).dup
      self.adjuntable.historico.last.update_attribute( 'archivo_adjunto', img )
    end
  end
end
