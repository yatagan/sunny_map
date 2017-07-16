defmodule SunnyMap.Repo.Migrations.CreateShop do
  use Ecto.Migration

  def change do
    create table(:shops) do
      add :title, :string
      add :description, :text
      add :lat, :float
      add :lng, :float

      timestamps()
    end

  end
end
