require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
describe Proyecto::Correspondencia do

  before (:each) do
    @params = {:tipo=>'nuevo', :contenido=>'Esto es una prueba 2'}
    @correspond = Proyecto::Correspondencia.create!(@params)
  end

  it "should be valid" do
    @correspond.should be_valid
  end

  it "Should be each correspondencia have proyectos" do
    @correspond.proyectos.should have(1).items
  end
end
