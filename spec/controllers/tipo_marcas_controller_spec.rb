require 'spec_helper'

describe TipoMarcasController do

  def mock_tipo_marca(stubs={})
    @mock_tipo_marca ||= mock_model(TipoMarca, stubs)
  end

  describe "GET index" do
    it "assigns all tipo_marcases as @tipo_marcases" do
      TipoMarca.stub(:find).with(:all).and_return([mock_tipo_marca])
      get :index
      assigns[:tipo_marcas].should == [mock_tipo_marca]
    end
  end

  describe "GET show" do
    it "assigns the requested tipo_marca as @tipo_marca" do
      TipoMarca.stub(:find).with("37").and_return(mock_tipo_marca)
      get :show, :id => "37"
      assigns[:tipo_marca].should equal(mock_tipo_marca)
    end
  end

  describe "GET new" do
    it "assigns a new tipo_marca as @tipo_marca" do
      TipoMarca.stub(:new).and_return(mock_tipo_marca)
      get :new
      assigns[:tipo_marca].should equal(mock_tipo_marca)
    end
  end

  describe "GET edit" do
    it "assigns the requested tipo_marca as @tipo_marca" do
      TipoMarca.stub(:find).with("37").and_return(mock_tipo_marca)
      get :edit, :id => "37"
      assigns[:tipo_marca].should equal(mock_tipo_marca)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created tipo_marca as @tipo_marca" do
        TipoMarca.stub(:new).with({'these' => 'params'}).and_return(mock_tipo_marca(:save => true))
        post :create, :tipo_marca => {:these => 'params'}
        assigns[:tipo_marca].should equal(mock_tipo_marca)
      end

      it "redirects to the created tipo_marca" do
        TipoMarca.stub(:new).and_return(mock_tipo_marca(:save => true))
        post :create, :tipo_marca => {}
        response.should redirect_to(tipo_marca_url(mock_tipo_marca))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved tipo_marca as @tipo_marca" do
        TipoMarca.stub(:new).with({'these' => 'params'}).and_return(mock_tipo_marca(:save => false))
        post :create, :tipo_marca => {:these => 'params'}
        assigns[:tipo_marca].should equal(mock_tipo_marca)
      end

      it "re-renders the 'new' template" do
        TipoMarca.stub(:new).and_return(mock_tipo_marca(:save => false))
        post :create, :tipo_marca => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested tipo_marca" do
        TipoMarca.should_receive(:find).with("37").and_return(mock_tipo_marca)
        mock_tipo_marca.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :tipo_marca => {:these => 'params'}
      end

      it "assigns the requested tipo_marca as @tipo_marca" do
        TipoMarca.stub(:find).and_return(mock_tipo_marca(:update_attributes => true))
        put :update, :id => "1"
        assigns[:tipo_marca].should equal(mock_tipo_marca)
      end

      it "redirects to the tipo_marca" do
        TipoMarca.stub(:find).and_return(mock_tipo_marca(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(tipo_marca_url(mock_tipo_marca))
      end
    end

    describe "with invalid params" do
      it "updates the requested tipo_marca" do
        TipoMarca.should_receive(:find).with("37").and_return(mock_tipo_marca)
        mock_tipo_marca.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :tipo_marca => {:these => 'params'}
      end

      it "assigns the tipo_marca as @tipo_marca" do
        TipoMarca.stub(:find).and_return(mock_tipo_marca(:update_attributes => false))
        put :update, :id => "1"
        assigns[:tipo_marca].should equal(mock_tipo_marca)
      end

      it "re-renders the 'edit' template" do
        TipoMarca.stub(:find).and_return(mock_tipo_marca(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested tipo_marca" do
      TipoMarca.should_receive(:find).with("37").and_return(mock_tipo_marca)
      mock_tipo_marca.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the tipo_marcas list" do
      TipoMarca.stub(:find).and_return(mock_tipo_marca(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(tipo_marcas_url)
    end
  end

end
