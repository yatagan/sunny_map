defmodule SunnyMap.Shop do
  use SunnyMap.Web, :model
  require Poison

  schema "shops" do
    field :title, :string
    field :description, :string
    field :lat, :float
    field :lng, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :lat, :lng])
    |> validate_required([:title, :description, :lat, :lng])
  end

  def serialize(shop) do
    %{
      "id": shop.id,
      "title": shop.title,
      "description": shop.description,
      "location": %{"lat": shop.lat, "lng": shop.lng},
      "infowindow": "make me"
    }
  end
end
