require 'spec_helper'

describe "/tipo_marcas/new.html.erb" do
  include TipoMarcasHelper

  before(:each) do
    assigns[:tipo_marca] = stub_model(TipoMarca,
      :new_record? => true,
      :nombre => "value for nombre",
      :descripcion => "value for descripcion"
    )
  end

  it "renders new tipo_marca form" do
    render

    response.should have_tag("form[action=?][method=post]", tipo_marcas_path) do
      with_tag("input#tipo_marca_nombre[name=?]", "tipo_marca[nombre]")
      with_tag("input#tipo_marca_descripcion[name=?]", "tipo_marca[descripcion]")
    end
  end
end
