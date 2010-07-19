class Adjunto < ActiveRecord::Base
  belongs_to :adjuntable, :polymorphic => true

  has_attached_file :archivo, :styles => { :mini => "100x100>" }

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

end
