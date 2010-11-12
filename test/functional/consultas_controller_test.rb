require 'test_helper'

class ConsultasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:consultas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create consulta" do
    assert_difference('Consulta.count') do
      post :create, :consulta => { }
    end

    assert_redirected_to consulta_path(assigns(:consulta))
  end

  test "should show consulta" do
    get :show, :id => consultas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => consultas(:one).to_param
    assert_response :success
  end

  test "should update consulta" do
    put :update, :id => consultas(:one).to_param, :consulta => { }
    assert_redirected_to consulta_path(assigns(:consulta))
  end

  test "should destroy consulta" do
    assert_difference('Consulta.count', -1) do
      delete :destroy, :id => consultas(:one).to_param
    end

    assert_redirected_to consultas_path
  end
end
