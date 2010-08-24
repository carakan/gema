require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Marca do
  before(:each) do
    @params ={"tipo_marca_id"=>1, "numero_registro"=>"95864-C", "importado"=>false, 
        "fecha_importacion"=>'2010-08-08', "errores"=>nil, "valido"=>true, 
        "fecha_registro"=>nil, "nombre"=>"AMISPED", "numero_gaceta"=>"2482", 
        "estado_serial"=> {}, "estado_fecha"=> Time.now, "cambios"=>["estado", "productos"], 
        "anterior"=>false, "numero_solicitud"=>"3969-2002", "titular_ids_serial"=>[], "numero_publicacion"=>"105121",
        "agente_ids_serial"=>[], "activa"=>true, "propia"=>true, "parent_id"=>0, "fecha_publicacion"=>'2010-08-08', 
        "estado"=>"sm", "errores_manual"=>nil, "pais_id"=>1, "clase_id"=>5, "tipo_signo_id"=>1,
        "productos"=>"Productos farmacéuticos, veterinarios e higiénicos, productos dietéticos para niños y enfermos, emplastros, material para vendajes, materiales para empastar dientes y para improntas dentales, desinfectantes, preparaciones para destruir las malas hierb"
    }  
    Usuario.create!(:nombre => 'Admin', :login => 'admin', :password => 'demo123', :password_confirmation => 'demo123', :rol_id => 1 )

    UsuarioSession.current_user = Usuario.first

    @m = Marca.create!(@params)
  end

  it 'Debe crear el metodo agente_ids' do
    @m.agente_ids.should == []
    @m.titular_ids.should == []
  end

  it 'debe crear metodo agentes' do
    @m.agentes.should == []
  end

  it 'debe dar error si no se asigna un array' do
    lambda{ @m.agente_ids = 1 }.should raise_error
  end

  it 'debe crear Instancias de MarcaRepresentante' do
    arr = [1, 2]
    @m.agente_ids = arr
    MarcaRepresentante.find(arr).map(&:id).should == arr
  end

  it 'debe tener los tipos correctos' do
    arr = [1, 2]
    @m.agente_ids = arr
    MarcaRepresentante.find(arr).each do |v|
      v.representable_type.should == 'Agente'
    end
  end

  it 'debe actualizar Instancias de MarcaRepresentante' do
    arr = [1, 2, 3]
    @m.agente_ids = arr
    @m.agente_ids = [1, 4]
    MarcaRepresentante.all.map(&:id).should == [1, 4]
  end

  it 'debe poder asignar titulares y agentes' do
    arr = [1, 2, 3]
    @m.agente_ids = arr
    @m.titular_ids = [1, 4]

    MarcaRepresentante.all(:conditions => {:representable_type => 'Agente'} ).map(&:representable_id).should == [1, 2, 3]
    MarcaRepresentante.all(:conditions => {:representable_type => 'Titular'} ).map(&:representable_id).should == [1, 4]
    
  end

  it 'debe asignar titular y agente con el mismo id' do
    arr = [1]
    @m.agente_ids = arr
    @m.titular_ids = arr

    MarcaRepresentante.all(:conditions => {:representable_type => 'Agente'} ).map(&:representable_id).should == arr
    MarcaRepresentante.all(:conditions => {:representable_type => 'Titular'} ).map(&:representable_id).should == arr
    
  end

  it 'marca debe poder asignar agente_ids y titular_ids' do
    
  end

  it 'debe buscar modelo a la derecha' do
    ids  = []
    ids << Representante.create(:nombre => 'Juan Perez').id
    ids << Representante.create(:nombre => 'Ana Torroja').id

    @m.agente_ids = ids
    @m.titular_ids = [ids.first]
    @m.agentes.map(&:nombre).should == ['Juan Perez', 'Ana Torroja']
    @m.titulares.map(&:nombre).should == ['Juan Perez']
  end

end
