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
  end

end
