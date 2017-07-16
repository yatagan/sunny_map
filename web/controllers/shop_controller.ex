defmodule SunnyMap.ShopController do
  use SunnyMap.Web, :controller
  require Logger

  alias SunnyMap.Shop

  def index(conn, _params) do
    shops = Repo.all(Shop)
    render(conn, "index.html", shops: shops)
  end

  def shops_json(conn, _params) do
    shops = Repo.all(Shop)
    json conn, Enum.map(shops, fn(s) -> SunnyMap.Shop.serialize(s) end)
  end

  def new(conn, _params) do
    changeset = Shop.changeset(%Shop{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"shop" => shop_params}) do
    changeset = Shop.changeset(%Shop{}, shop_params)

    case Repo.insert(changeset) do
      {:ok, _shop} ->
        conn
        |> put_flash(:info, "Shop created successfully.")
        |> redirect(to: shop_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    shop = Repo.get!(Shop, id)
    render(conn, "show.html", shop: shop)
  end

  def edit(conn, %{"id" => id}) do
    shop = Repo.get!(Shop, id)
    changeset = Shop.changeset(shop)
    render(conn, "edit.html", shop: shop, changeset: changeset)
  end

  def update(conn, %{"id" => id, "shop" => shop_params}) do
    shop = Repo.get!(Shop, id)
    changeset = Shop.changeset(shop, shop_params)

    case Repo.update(changeset) do
      {:ok, shop} ->
        conn
        |> put_flash(:info, "Shop updated successfully.")
        |> redirect(to: shop_path(conn, :show, shop))
      {:error, changeset} ->
        render(conn, "edit.html", shop: shop, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    shop = Repo.get!(Shop, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(shop)

    conn
    |> put_flash(:info, "Shop deleted successfully.")
    |> redirect(to: shop_path(conn, :index))
  end
end
