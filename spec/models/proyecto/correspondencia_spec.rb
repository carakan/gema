require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Proyeco::Correspondencia do
  it "should be valid" do
    Correspondencia.new.should be_valid
  end
end
