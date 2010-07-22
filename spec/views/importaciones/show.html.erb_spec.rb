require 'spec_helper'

describe "/importaciones/show.html.erb" do
  include ImportacionesHelper
  before(:each) do
    assigns[:importacion] = @importacion = stub_model(Importacion,
      :completa => false
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/false/)
  end
end
