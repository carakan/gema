class Representante < ActiveRecord::Base
  #before_validation :set_validar
  #before_save :strip_data

  #has_and_belongs_to_many :agentes, :class_name => 'Representante',
  #  :association_foreign_key => :agente_id,
  #  :join_table => 'marcas_agentes'
  #has_and_belongs_to_many :titulares, :class_name => 'Representante',
  #  :association_foreign_key => :titular_id,
  #  :join_table => 'marcas_titulares'

  belongs_to :pais
  
  #has_many :posts, :order => 'created_at DESC'
  has_many :posts, :as => :postable, :dependent => :destroy
  has_many :adjuntos, :as => :adjuntable, :dependent => :destroy

  validates_presence_of :nombre
  validates_format_of :email, :with => Constants::EMAIL_REG, 
    :unless => lambda{ |r| r.email.blank? }

  attr_accessor :validar

  def to_s
    nombre
  end

  # Retorna todos los titulares de las marcas seleccionadas
  def self.titular_ids(marca_ids = [])
    find_by_sql( ["SELECT titular_id FROM marcas_titulares WHERE marca_id IN (?)", marca_ids ] ).map(&:titular_id).uniq
  end

  def self.agente_ids(marca_ids = [])
    find_by_sql( ["SELECT agente_id FROM marcas_agentes WHERE marca_id IN (?)", marca_ids ] ).map(&:agente_id).uniq
  end



private
  # Prepara el atributo validar
  def set_validar
    self.validar = true if validar.nil?
  end

  #def strip_data
  #  [:nombre, :email, :direccion, :telefono, :movil].each do |v|
  #    self.send("#{v}=", send(v).strip) unless self.send(v).nil?
  #  end
  #end

end
