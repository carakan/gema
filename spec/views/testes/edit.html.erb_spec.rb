require 'spec_helper'

describe "/testes/edit.html.erb" do
  include TestesHelper

  before(:each) do
    assigns[:test] = @test = stub_model(Test,
      :new_record? => false
    )
  end

  it "renders the edit test form" do
    render

    response.should have_tag("form[action=#{test_path(@test)}][method=post]") do
    end
  end
end
