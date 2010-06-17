require 'spec_helper'

describe "/tipo_marcas/index.html.erb" do
  include TipoMarcasHelper

  before(:each) do
    assigns[:tipo_marcas] = [
      stub_model(TipoMarca,
        :nombre => "value for nombre",
        :descripcion => "value for descripcion"
      ),
      stub_model(TipoMarca,
        :nombre => "value for nombre",
        :descripcion => "value for descripcion"
      )
    ]
  end

  it "renders a list of tipo_marcas" do
    render
    response.should have_tag("tr>td", "value for nombre".to_s, 2)
    response.should have_tag("tr>td", "value for descripcion".to_s, 2)
  end
end
