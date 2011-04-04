require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')


before(:each) do
  @params={}
  @proy = Proyecto::Proyecto.create!(@params)
  
end
describe Proyecto do
  it "should be valid" do
    @proy.new.should be_valid
  end
end
