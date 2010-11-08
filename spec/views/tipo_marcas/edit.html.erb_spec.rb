require 'spec_helper'

describe "/tipo_marcas/edit.html.erb" do
  include TipoMarcasHelper

  before(:each) do
    assigns[:tipo_marca] = @tipo_marca = stub_model(TipoMarca,
      :new_record? => false,
      :nombre => "value for nombre",
      :descripcion => "value for descripcion"
    )
  end

  it "renders the edit tipo_marca form" do
    render

    response.should have_tag("form[action=#{tipo_marca_path(@tipo_marca)}][method=post]") do
      with_tag('input#tipo_marca_nombre[name=?]', "tipo_marca[nombre]")
      with_tag('input#tipo_marca_descripcion[name=?]', "tipo_marca[descripcion]")
    end
  end
end
