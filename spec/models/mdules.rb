require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Modulos clases" do

  it 'debe cambiar acentos' do
    "aguíta".cambiar_acentos.should == "aguita"
    "agüítón".cambiar_acentos.should == "aguiton"
    "äáéëíóöúü".cambiar_acentos.should == "aaeeioouu"
  end
  
end
