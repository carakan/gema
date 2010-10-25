require 'spec_helper'

describe Reporte do
  before(:each) do
    @reporte = Reporte.new(:texto_es =>"hola a atodos **hola** a todos los lque esta **veamos** hola a atodos **veamos**")
  end

  it "should extract params" do
    @reporte.extract_variables.size.should == 3
  end

  it "should extract text" do
    texts = @reporte.extract_text
    texts.size.should == 3
    debugger
    texts[0].should == "hola a atodos "
    texts[1].should ==" a todos los lque esta "
    texts[2].should == " hola a atodos "
  end
  
end
