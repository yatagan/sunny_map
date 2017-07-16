defmodule SunnyMap.ShopTest do
  use SunnyMap.ModelCase

  alias SunnyMap.Shop

  @valid_attrs %{description: "some content", lat: "120.5", lng: "120.5", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Shop.changeset(%Shop{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Shop.changeset(%Shop{}, @invalid_attrs)
    refute changeset.valid?
  end
end
