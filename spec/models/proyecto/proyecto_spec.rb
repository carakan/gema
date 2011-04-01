require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Proyecto do
  it "should be valid" do
    Proyecto.new.should be_valid
  end
end
