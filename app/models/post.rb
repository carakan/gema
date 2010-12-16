# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class Post < ActiveRecord::Base
  before_save :adicionar_usuario
  before_save :new_line_to_br

  belongs_to :usuario
  belongs_to :postable, :polymorphic => true

  has_many :adjuntos, :as => :adjuntable, :dependent => :destroy
  accepts_nested_attributes_for :adjuntos, :reject_if => lambda { |a| a[:archivo].blank? }

  validates_presence_of :titulo, :comentario
  CATEGORIA_POST = ["Renovaciones","Inscripciones cambios titular, domicilio y licencias", "Litigios", "Otro"]
private
  def adicionar_usuario
    self.usuario_id = UsuarioSession.current_user[:id]
  end
  
  def new_line_to_br
    self.comentario = comentario.gsub(/\n/, '<br />').strip
  end
end
