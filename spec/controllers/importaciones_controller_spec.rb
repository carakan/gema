require 'spec_helper'

describe ImportacionesController do

  def mock_importacion(stubs={})
    @mock_importacion ||= mock_model(Importacion, stubs)
  end

  describe "GET index" do
    it "assigns all importacioneses as @importacioneses" do
      Importacion.stub(:find).with(:all).and_return([mock_importacion])
      get :index
      assigns[:importaciones].should == [mock_importacion]
    end
  end

  describe "GET show" do
    it "assigns the requested importacion as @importacion" do
      Importacion.stub(:find).with("37").and_return(mock_importacion)
      get :show, :id => "37"
      assigns[:importacion].should equal(mock_importacion)
    end
  end

  describe "GET new" do
    it "assigns a new importacion as @importacion" do
      Importacion.stub(:new).and_return(mock_importacion)
      get :new
      assigns[:importacion].should equal(mock_importacion)
    end
  end

  describe "GET edit" do
    it "assigns the requested importacion as @importacion" do
      Importacion.stub(:find).with("37").and_return(mock_importacion)
      get :edit, :id => "37"
      assigns[:importacion].should equal(mock_importacion)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created importacion as @importacion" do
        Importacion.stub(:new).with({'these' => 'params'}).and_return(mock_importacion(:save => true))
        post :create, :importacion => {:these => 'params'}
        assigns[:importacion].should equal(mock_importacion)
      end

      it "redirects to the created importacion" do
        Importacion.stub(:new).and_return(mock_importacion(:save => true))
        post :create, :importacion => {}
        response.should redirect_to(importacion_url(mock_importacion))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved importacion as @importacion" do
        Importacion.stub(:new).with({'these' => 'params'}).and_return(mock_importacion(:save => false))
        post :create, :importacion => {:these => 'params'}
        assigns[:importacion].should equal(mock_importacion)
      end

      it "re-renders the 'new' template" do
        Importacion.stub(:new).and_return(mock_importacion(:save => false))
        post :create, :importacion => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested importacion" do
        Importacion.should_receive(:find).with("37").and_return(mock_importacion)
        mock_importacion.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :importacion => {:these => 'params'}
      end

      it "assigns the requested importacion as @importacion" do
        Importacion.stub(:find).and_return(mock_importacion(:update_attributes => true))
        put :update, :id => "1"
        assigns[:importacion].should equal(mock_importacion)
      end

      it "redirects to the importacion" do
        Importacion.stub(:find).and_return(mock_importacion(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(importacion_url(mock_importacion))
      end
    end

    describe "with invalid params" do
      it "updates the requested importacion" do
        Importacion.should_receive(:find).with("37").and_return(mock_importacion)
        mock_importacion.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :importacion => {:these => 'params'}
      end

      it "assigns the importacion as @importacion" do
        Importacion.stub(:find).and_return(mock_importacion(:update_attributes => false))
        put :update, :id => "1"
        assigns[:importacion].should equal(mock_importacion)
      end

      it "re-renders the 'edit' template" do
        Importacion.stub(:find).and_return(mock_importacion(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested importacion" do
      Importacion.should_receive(:find).with("37").and_return(mock_importacion)
      mock_importacion.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the importaciones list" do
      Importacion.stub(:find).and_return(mock_importacion(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(importaciones_url)
    end
  end

end
