require File.dirname(__FILE__) + '/../spec_helper'

describe Proyecto::InstruccionDetallesController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => Proyecto::InstruccionDetalle.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    Proyecto::InstruccionDetalle.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Proyecto::InstruccionDetalle.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(proyecto/instruccion_detalle_url(assigns[:proyecto/instruccion_detalle]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => Proyecto::InstruccionDetalle.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    Proyecto::InstruccionDetalle.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Proyecto::InstruccionDetalle.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Proyecto::InstruccionDetalle.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Proyecto::InstruccionDetalle.first
    response.should redirect_to(proyecto/instruccion_detalle_url(assigns[:proyecto/instruccion_detalle]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    proyecto/instruccion_detalle = Proyecto::InstruccionDetalle.first
    delete :destroy, :id => proyecto/instruccion_detalle
    response.should redirect_to(proyecto/instruccion_detalles_url)
    Proyecto::InstruccionDetalle.exists?(proyecto/instruccion_detalle.id).should be_false
  end
end
