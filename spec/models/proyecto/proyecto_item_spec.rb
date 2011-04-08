require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Proyecto::ProyectoItem do
  it "should be valid" do
    Proyecto::ProyectoItem.new.should be_valid
  end
end
