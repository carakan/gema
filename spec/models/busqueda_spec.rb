require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Busqueda do

  it '1 a 3 letras igual' do
    b = Busqueda.buscar('TA')
    b.expresiones.should == [{1 => 'ta'}]
  end

  #it '1 a 3 letras cambio de i por e' do
  #  b = Busqueda.buscar('be')
  #  b.expresiones.should == [{1 => 'be'}, {2 => 'bi'}]
  #end

  it 'debe retornar con 3 letras' do
    b = Busqueda.buscar('bei')
    b.expresiones.should == [{1 => 'bei'}, {2 => 'bii'}, {2 => 'bee'}]
    b = Busqueda.buscar('tou')
    b.expresiones.should == [{1 => 'tou'}, {2 => 'tuu'}, {2 => 'too'}]
  end

  it 'debe buscar 4 letras' do
    b = Busqueda.buscar('agel')
    b.expresiones.should == [{1 => 'agel'}, {2 => 'age'}, {2 => 'gel'}]
    b = Busqueda.buscar('hola')
    b.expresiones.should == [{1 => 'hola'}, {2 => 'hol'}, {2 => 'ola'}]
    b = Busqueda.buscar('tome')
    b.expresiones.should == [{1 => 'tome'}, {2 => 'tom'}, {2 => 'ome'}]
  end

  it 'debe buscar con 5 letras' do
    b = Busqueda.buscar('facil')
    b.expresiones.should == [{1 => 'facil'}, {2 => 'fac'}, {2 => 'aci'}, {2 => 'cil'}, {3 => 'fa'}, {3 => 'il'}]
    b = Busqueda.buscar('daire')
    b.expresiones.should == [{1 => 'daire'}, {2 => 'dai'}, {2 => 'air'}, {2 => 'ire'}, {3 => 'da'}, {3 => 're'}]
  end

  it 'debe buscar en 6 letras' do
    b = Busqueda.buscar('cobija')
    b.expresiones.should == [{1 => 'cobija'}, {2 => 'cob'}, {2 => 'obi'}, 
      {2 => 'bij'}, {2 => 'ija'}, 
      {3 => "c#{Constants::LETRAS_REG}b#{Constants::LETRAS_REG}j#{Constants::LETRAS_REG}"}, 
      {3 => "#{Constants::LETRAS_REG}o#{Constants::LETRAS_REG}i#{Constants::LETRAS_REG}a"}]
  end

end
