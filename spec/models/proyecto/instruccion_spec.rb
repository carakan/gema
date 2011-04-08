require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Proyecto::Instruccion do
  it "should be valid" do
    Proyecto::Instruccion.new.should be_valid
  end
end
