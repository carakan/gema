class Post < ActiveRecord::Base
  before_save :adicionar_usuario
  before_save :new_line_to_br

  belongs_to :marca
  belongs_to :usuario

  has_many :adjuntos, :as => :adjuntable, :dependent => :destroy
  accepts_nested_attributes_for :adjuntos, :reject_if => lambda { |a| a[:archivo].blank? }

  validates_presence_of :titulo, :comentario


private
  def adicionar_usuario
    self.usuario_id = UsuarioSession.current_user[:id]
  end
  
  def new_line_to_br
    self.comentario.gsub!(/\n/, '<br />')
  end
end
