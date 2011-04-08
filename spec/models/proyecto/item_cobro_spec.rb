require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Proyecto::ItemCobro do
  it "should be valid" do
    Proyecto::ItemCobro.new.should be_valid
  end
end
