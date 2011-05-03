require File.dirname(__FILE__) + '/../spec_helper'

describe TipoInstruccion do
  it "should be valid" do
    TipoInstruccion.new.should be_valid
  end
end
