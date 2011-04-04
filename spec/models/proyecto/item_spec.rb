require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Proyecto::Item do
  it "should be valid" do
    Proyecto::Item.new.should be_valid
  end
end
