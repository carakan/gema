require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Busqueda do
  before(:each) do
    class Prueba
      attr_reader :busqueda

      def initialize(bus)
        @busqueda = bus
      end
    end
  end


  it '1 a 3 letras igual' do
    b = Busqueda.buscar('TA')
    b.expresiones[1].should == ['ta']
  end

  it '1 a 3 letras cambio de i por e' do
    b = Busqueda.buscar('be')
    b.expresiones.should == {1 => ['be'], 4 => ['bi']}
  end

  it 'debe retornar con 3 letras' do
    b = Busqueda.buscar('bei')
    b.expresiones.should == {1 => ['bei'], 4 => ['bii', 'bee'] }
    b = Busqueda.buscar('tou')
    b.expresiones.should == {1 => ['tou'], 4 => ['tuu', 'too'] }
  end

  it 'debe dividir y encontrar los indices de una palabra' do
    Prueba.send(:include, BusquedaCambio)
    p = Prueba.new('gelicesi')
    p.buscar_indices_palabra
    p.indices_palabra.should == [
      [ 0, { :vals => ["ge", "je"], :size => 2 }],
      [ 3, { :vals => ['i', 'y'], :size => 1 }],
      [ 4, { :vals => ["ce", "ze", "se"], :size => 2  }],
      [ 6, { :vals => ["ci", "zi", "si"], :size => 2 }],
      [ 7, { :vals => ['i', 'y'], :size => 1 }]
    ]

  end

  it 'debe identificar para una letra' do
    Prueba.send(:include, BusquedaCambio)
    p = Prueba.new('anfi')
    p.buscar_indices_palabra
    p.indices_palabra.should == [
      [ 2, { :vals => ["f", "ph"], :size => 1 } ],
      [ 3, { :vals => ["i", "y"], :size => 1 } ]
    ]
  end

  it 'debe retornar todos los elementos' do
    Prueba.send(:include, BusquedaCambio)
    p = Prueba.new('gelicesi')
    p.buscar_indices_palabra
    p.obtener_array_silabas.should == [
      ["ge", "je"], 
      ["i", "y"],
      ["ce", "ze", "se"], 
      ["ci", "zi", "si"], 
      ["i", "y"]
    ]
  end


  it 'debe cambiar elementos de una letra' do
    p = Prueba.send(:include, BusquedaCambio)
    p = Prueba.new('vhya')
    p.combinaciones_palabra.sort.should == ["bhia", "bhya", "bia", "bya", 
    "bjia", "bjya", "vhia", "via", "vya", "vjia", "vjya"].sort
  end

  it 'debe realizar la busqueda con 4 letras' do
    b = Busqueda.new('vhya')
    b.expresiones[1].should == ['vhya']
    b.expresiones[2].sort.should == [ "bhia", "bhya", "bia", "bya",
    "bjia", "bjya", "vhia", "via", "vya", "vjia", "vjya"].sort
    b.expresiones[3].should == ["v[a-zñáéíóú]y[a-zñáéíóú]", "[a-zñáéíóú]h[a-zñáéíóú]a"]
  end

  it 'debe poder cambiar oo por u, u' do
    p = Prueba.send(:include, BusquedaCambio)
    p = Prueba.new('aool')
    p.combinaciones_palabra.sort.should == ['aol', 'aul'].sort
  end

  it 'cs por x, ll por l, ph por f' do
    p = Prueba.send(:include, BusquedaCambio)
    p = Prueba.new('cctlli')
    p.combinaciones_palabra.sort.should == [
      "cctlly", "cctli", "cctly",
      "cstlli", "cstlly", "cstli", "cstly",
      "cztlli", "cztlly", "cztli", "cztly",
      "xtlli", "xtlly", "xtli", "xtly" ].sort
  end



  it 'debe buscar con 5 letras' do
    b = Busqueda.buscar('fácil')
    b.expresiones[1].should == ['facil']
    b.expresiones[2].sort.should == ['facyl', 'fasil', 'fasyl', 'fazil', 'fazyl',
    'phacil', 'phacyl', 'phasil', 'phasyl', 'phazil', 'phazyl']

    b.expresiones[4].should == ['fac', 'aci', 'cil', 'fa', 'il']
  end


  it 'debe buscar 7 letras' do
    b = Busqueda.buscar('dominos')
    b.expresiones[3].should ==  [
      "d#{Constants::LETRAS_REG}m#{Constants::LETRAS_REG}n#{Constants::LETRAS_REG}s" ,
      "#{Constants::LETRAS_REG}o#{Constants::LETRAS_REG}i#{Constants::LETRAS_REG}o#{Constants::LETRAS_REG}"]
  end

  it 'debe buscar 8 y 9 letras' do
    b = Busqueda.buscar('salvieti')
    b.expresiones[4].should == ['salv', 'alvi', 'lvie', 'viet', 'ieti']
    b.expresiones[3].should == [
      "s#{Constants::LETRAS_REG}l#{Constants::LETRAS_REG}i#{Constants::LETRAS_REG}t#{Constants::LETRAS_REG}",
      "#{Constants::LETRAS_REG}a#{Constants::LETRAS_REG}v#{Constants::LETRAS_REG}e#{Constants::LETRAS_REG}i"]

    b = Busqueda.buscar('salvietis')
    b.expresiones[2].sort.should == ["salbietis", "salbietys", "salbyetis", "salbyetys", "salvietys", "salvyetis", "salvyetys"].sort
    b.expresiones[4].should == ['salv', 'alvi', 'lvie', 
      'viet', 'ieti', 'etis']
    b.expresiones[3].should == [
      "s#{Constants::LETRAS_REG}l#{Constants::LETRAS_REG}i#{Constants::LETRAS_REG}t#{Constants::LETRAS_REG}s", 
      "#{Constants::LETRAS_REG}a#{Constants::LETRAS_REG}v#{Constants::LETRAS_REG}e#{Constants::LETRAS_REG}i#{Constants::LETRAS_REG}"]

  end

end
