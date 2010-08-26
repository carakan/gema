class Agente < Representante
  #has_many :marcas_representantes, :as => :representable
  #has_many :marcas, :through => :representable
  #has_and_belongs_to_many :marcas, 
  #  :foreign_key => :representante_id,
  #  :join_table => 'marcas_representantes'
  
  def ultimos_posts(limit = 2)
    Post.all(:conditions => { :agente_ids => self.id }, 
             :limit => limit, :order => 'created_at DESC' )
    #Post.all(:conditions => { :titular_id => self.id }, 
             #:limit => limit, :order => 'created_at DESC' )

  end

end
