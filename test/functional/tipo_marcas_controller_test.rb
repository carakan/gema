require 'test_helper'

class TipoMarcasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipo_marcas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipo_marca" do
    assert_difference('TipoMarca.count') do
      post :create, :tipo_marca => { }
    end

    assert_redirected_to tipo_marca_path(assigns(:tipo_marca))
  end

  test "should show tipo_marca" do
    get :show, :id => tipo_marcas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tipo_marcas(:one).to_param
    assert_response :success
  end

  test "should update tipo_marca" do
    put :update, :id => tipo_marcas(:one).to_param, :tipo_marca => { }
    assert_redirected_to tipo_marca_path(assigns(:tipo_marca))
  end

  test "should destroy tipo_marca" do
    assert_difference('TipoMarca.count', -1) do
      delete :destroy, :id => tipo_marcas(:one).to_param
    end

    assert_redirected_to tipo_marcas_path
  end
end
