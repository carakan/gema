require 'spec_helper'

describe "/importaciones/new.html.erb" do
  include ImportacionesHelper

  before(:each) do
    assigns[:importacion] = stub_model(Importacion,
      :new_record? => true,
      :completa => false
    )
  end

  it "renders new importacion form" do
    render

    response.should have_tag("form[action=?][method=post]", importaciones_path) do
      with_tag("input#importacion_completa[name=?]", "importacion[completa]")
    end
  end
end
