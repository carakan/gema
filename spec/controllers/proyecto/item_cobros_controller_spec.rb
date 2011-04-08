require File.dirname(__FILE__) + '/../spec_helper'

describe Proyecto::ItemCobrosController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => Proyecto::ItemCobro.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    Proyecto::ItemCobro.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Proyecto::ItemCobro.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(proyecto/item_cobro_url(assigns[:proyecto/item_cobro]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => Proyecto::ItemCobro.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    Proyecto::ItemCobro.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Proyecto::ItemCobro.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Proyecto::ItemCobro.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Proyecto::ItemCobro.first
    response.should redirect_to(proyecto/item_cobro_url(assigns[:proyecto/item_cobro]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    proyecto/item_cobro = Proyecto::ItemCobro.first
    delete :destroy, :id => proyecto/item_cobro
    response.should redirect_to(proyecto/item_cobros_url)
    Proyecto::ItemCobro.exists?(proyecto/item_cobro.id).should be_false
  end
end
