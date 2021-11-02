defmodule UrlShortener.Repo.Migrations.AddUrlTable do
  use Ecto.Migration

  def change do
    create table(:url) do
      add :slug, :string, null: false
      add :target, :string, null: false

      timestamps()
    end

    create unique_index(:url, [:slug])
  end
end
