require 'spec_helper'

describe "/tipo_marcas/show.html.erb" do
  include TipoMarcasHelper
  before(:each) do
    assigns[:tipo_marca] = @tipo_marca = stub_model(TipoMarca,
      :nombre => "value for nombre",
      :descripcion => "value for descripcion"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ nombre/)
    response.should have_text(/value\ for\ descripcion/)
  end
end
