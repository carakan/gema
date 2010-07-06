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
    b.expresiones.should == {1 => ['be'], 2 => ['bi']}
  end

  it 'debe retornar con 3 letras' do
    b = Busqueda.buscar('bei')
    b.expresiones.should == {1 => ['bei'], 2 => ['bii', 'bee'] }
    b = Busqueda.buscar('tou')
    b.expresiones.should == {1 => ['tou'], 2 => ['tuu', 'too'] }
  end

  it 'debe dividir y encontrar los indices de una palabra' do
    Prueba.send(:include, BusquedaCambio)
    p = Prueba.new('gelicesi')
    p.buscar_indices_palabras
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
    p.buscar_indices_palabras
    p.indices_palabra.should == [
      [ 2, { :vals => ["f", "ph"], :size => 1 } ],
      [ 3, { :vals => ["i", "y"], :size => 1 } ]
    ]
  end

  it 'debe retornar todos los elementos' do
    Prueba.send(:include, BusquedaCambio)
    p = Prueba.new('gelicesi')
    p.buscar_indices_palabras
    p.obtener_array_silabas.should == [
      ["ge", "je"], 
      ["i", "y"],
      ["ce", "ze", "se"], 
      ["ci", "zi", "si"], 
      ["i", "y"]
    ]
  end

  #it 'debe crear las combinaciones para la palabra' do
  #  p = Prueba.send(:include, BusquedaCambio)
  #  p = Prueba.new('gelicesi')
  #  p.combinaciones_palabra.sort.should == [
  #    "geliceci", "gelicecy", 
  #    "gelicesi", "gelicesy", "gelicezi", 
  #    "gelicezy", "geliseci", "gelisecy", 
  #    "gelisesi", "gelisesy", "gelisezi", 
  #    "gelisezy", "gelizeci", "gelizecy", 
  #    "gelizesi", "gelizesy", "gelizezi", 
  #    "gelizezy", "gelyceci", "gelycecy", 
  #    "gelycesi", "gelycesy", "gelycezi", 
  #    "gelycezy", "gelyseci", "gelysecy", 
  #    "gelysesi", "gelysesy", "gelysezi",
  #    "gelysezy", "gelyzeci", "gelyzecy",
  #    "gelyzesi", "gelyzesy", "gelyzezi",
  #    "gelyzezy", "jeliceci", "jelicecy",
  #    "jelicesi", "jelicesy", "jelicezi",
  #    "jelicezy", "jeliseci", "jelisecy",
  #    "jelisesi", "jelisesy", "jelisezi",
  #    "jelisezy", "jelizeci", "jelizecy",
  #    "jelizesi", "jelizesy", "jelizezi",
  #    "jelizezy", "jelyceci", "jelycecy",
  #    "jelycesi", "jelycesy", "jelycezi",
  #    "jelycezy", "jelyseci", "jelysecy", 
  #    "jelysesi", "jelysesy", "jelysezi",
  #    "jelysezy", "jelyzeci", "jelyzecy",
  #    "jelyzesi", "jelyzesy", "jelyzezi", "jelyzezy"]
  #end


  it 'debe cambiar elementos de una letra' do
    p = Prueba.send(:include, BusquedaCambio)
    p = Prueba.new('vhya')
    p.combinaciones_palabra.should == ["bia", "bya", "bjia", "bjya", "via", "vya", "vjia", "vjya"]
  end

  it 'debe poder cambiar oo por u, u' do
    p = Prueba.send(:include, BusquedaCambio)
    p = Prueba.new('aool')
    p.combinaciones_palabra.should == ['aol', 'aul']

  end


  #it 'debe buscar 4 letras' do
  #  b = Busqueda.buscar('agel')
  #  b.expresiones.should == {1 => [ 'agel' ], 2 => [ 'age', 'gel' ]}
  #  b = Busqueda.buscar('hola')
  #  b.expresiones.should == {1 => ['hola'], 2 => [ 'hol', 'ola' ]}
  #end

  #it 'debe realizar cambio con 5 letras' do
  #  b = Busqueda.new('ácil')
  #  b.expresiones.should == {1 => ['acil'], 2 => ['aci',  'cil'],
  #    3 => ['asi', 'sil', 'azi', 'zil']
  #  }
  #  
  #end

  #it 'debe buscar con 5 letras' do
  #  b = Busqueda.buscar('facil')
  #  b.expresiones.should == {1 => ['facil', 'fasil', 'fazil'], 2 => [ 'fac', 'aci', 'cil' ], 
  #     3 => [ 'fa', 'il' ]}
  #  #b = Busqueda.buscar('daire')
  #  #b.expresiones.should == [{1 => 'daire'}, {2 => 'dai'}, {2 => 'air'}, {2 => 'ire'}, {3 => 'da'}, {3 => 're'}]
  #end

  #it 'debe buscar en 6 letras' do
  #  b = Busqueda.buscar('cobija')
  #  b.expresiones.should == [{1 => 'cobija'}, {2 => 'cob'}, {2 => 'obi'}, 
  #    {2 => 'bij'}, {2 => 'ija'}, 
  #    {3 => "c#{Constants::LETRAS_REG}b#{Constants::LETRAS_REG}j#{Constants::LETRAS_REG}"}, 
  #    {3 => "#{Constants::LETRAS_REG}o#{Constants::LETRAS_REG}i#{Constants::LETRAS_REG}a"}]
  #end

  #it 'debe buscar 7 letras' do
  #  b = Busqueda.buscar('dominos')
  #  b.expresiones.should == [{1 => 'dominos'}, {2 => 'dom'}, {2 => 'omi'}, 
  #    {2 => 'min'}, {2 => 'ino'}, {2 => 'nos'},
  #    {3 => "d#{Constants::LETRAS_REG}m#{Constants::LETRAS_REG}n#{Constants::LETRAS_REG}s"}, 
  #    {3 => "#{Constants::LETRAS_REG}o#{Constants::LETRAS_REG}i#{Constants::LETRAS_REG}o#{Constants::LETRAS_REG}"}]
  #end

  #it 'debe buscar 8 y 9 letras' do
  #  b = Busqueda.buscar('salvieti')
  #  b.expresiones.should == [{1 => 'salvieti'}, {2 => 'salv'}, {2 => 'alvi'}, 
  #    {2 => 'lvie'}, {2 => 'viet'}, {2 => 'ieti'},
  #    {3 => "s#{Constants::LETRAS_REG}l#{Constants::LETRAS_REG}i#{Constants::LETRAS_REG}t#{Constants::LETRAS_REG}"}, 
  #    {3 => "#{Constants::LETRAS_REG}a#{Constants::LETRAS_REG}v#{Constants::LETRAS_REG}e#{Constants::LETRAS_REG}i"}]

  #  b = Busqueda.buscar('salvietis')
  #  b.expresiones.should == [{1 => 'salvietis'}, {2 => 'salv'}, {2 => 'alvi'}, 
  #    {2 => 'lvie'}, {2 => 'viet'}, {2 => 'ieti'}, {2 => 'etis'},
  #    {3 => "s#{Constants::LETRAS_REG}l#{Constants::LETRAS_REG}i#{Constants::LETRAS_REG}t#{Constants::LETRAS_REG}s"}, 
  #    {3 => "#{Constants::LETRAS_REG}a#{Constants::LETRAS_REG}v#{Constants::LETRAS_REG}e#{Constants::LETRAS_REG}i#{Constants::LETRAS_REG}"}]
  #end

  #it 'debe buscar 10 y 11 letras' do
  #  busq = 'comentario'
  #  b = Busqueda.buscar(busq)
  #  b.expresiones[0].values.first.should == 'comentario'
  #  (0..5).each{ |v| b.expresiones[v + 1].values.first.should == busq[v,5] }

  #  busq = 'comentarios'
  #  b = Busqueda.buscar(busq)
  #  b.expresiones[0].values.first.should == 'comentarios'
  #  (0..6).each{ |v| b.expresiones[v + 1].values.first.should == busq[v,5] }
  #end

  #it 'debe buscar 12 y 13 letras' do
  #  busq = 'publicación'
  #  b = Busqueda.buscar(busq)
  #  b.expresiones[0].values.first.should == 'publicación'
  #  (0..6).each{ |v| b.expresiones[v + 1].values.first.should == busq[v,6] }
  #end

end
