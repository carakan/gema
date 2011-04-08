require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Proyecto::ItemGasto do
  it "should be valid" do
    Proyecto::ItemGasto.new.should be_valid
  end
end
