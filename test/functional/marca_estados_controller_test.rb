require 'test_helper'

class MarcaEstadosControllerTest < ActionController::TestCase
  setup do
    @marca_estado = marca_estados(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:marca_estados)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create marca_estado" do
    assert_difference('MarcaEstado.count') do
      post :create, :marca_estado => @marca_estado.attributes
    end

    assert_redirected_to marca_estado_path(assigns(:marca_estado))
  end

  test "should show marca_estado" do
    get :show, :id => @marca_estado.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @marca_estado.to_param
    assert_response :success
  end

  test "should update marca_estado" do
    put :update, :id => @marca_estado.to_param, :marca_estado => @marca_estado.attributes
    assert_redirected_to marca_estado_path(assigns(:marca_estado))
  end

  test "should destroy marca_estado" do
    assert_difference('MarcaEstado.count', -1) do
      delete :destroy, :id => @marca_estado.to_param
    end

    assert_redirected_to marca_estadoses_path
  end
end
