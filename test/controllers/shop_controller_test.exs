defmodule SunnyMap.ShopControllerTest do
  use SunnyMap.ConnCase

  alias SunnyMap.Shop
  @valid_attrs %{description: "some content", lat: "120.5", lng: "120.5", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, shop_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing shops"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, shop_path(conn, :new)
    assert html_response(conn, 200) =~ "New shop"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, shop_path(conn, :create), shop: @valid_attrs
    assert redirected_to(conn) == shop_path(conn, :index)
    assert Repo.get_by(Shop, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, shop_path(conn, :create), shop: @invalid_attrs
    assert html_response(conn, 200) =~ "New shop"
  end

  test "shows chosen resource", %{conn: conn} do
    shop = Repo.insert! %Shop{}
    conn = get conn, shop_path(conn, :show, shop)
    assert html_response(conn, 200) =~ "Show shop"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, shop_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    shop = Repo.insert! %Shop{}
    conn = get conn, shop_path(conn, :edit, shop)
    assert html_response(conn, 200) =~ "Edit shop"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    shop = Repo.insert! %Shop{}
    conn = put conn, shop_path(conn, :update, shop), shop: @valid_attrs
    assert redirected_to(conn) == shop_path(conn, :show, shop)
    assert Repo.get_by(Shop, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    shop = Repo.insert! %Shop{}
    conn = put conn, shop_path(conn, :update, shop), shop: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit shop"
  end

  test "deletes chosen resource", %{conn: conn} do
    shop = Repo.insert! %Shop{}
    conn = delete conn, shop_path(conn, :delete, shop)
    assert redirected_to(conn) == shop_path(conn, :index)
    refute Repo.get(Shop, shop.id)
  end
end
