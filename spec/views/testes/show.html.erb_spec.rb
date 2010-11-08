require 'spec_helper'

describe "/testes/show.html.erb" do
  include TestesHelper
  before(:each) do
    assigns[:test] = @test = stub_model(Test)
  end

  it "renders attributes in <p>" do
    render
  end
end
