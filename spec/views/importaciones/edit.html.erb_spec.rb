require 'spec_helper'

describe "/importaciones/edit.html.erb" do
  include ImportacionesHelper

  before(:each) do
    assigns[:importacion] = @importacion = stub_model(Importacion,
      :new_record? => false,
      :completa => false
    )
  end

  it "renders the edit importacion form" do
    render

    response.should have_tag("form[action=#{importacion_path(@importacion)}][method=post]") do
      with_tag('input#importacion_completa[name=?]', "importacion[completa]")
    end
  end
end
