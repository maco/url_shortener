defmodule UrlShortener.Urls.Url do
  @moduledoc """
    Database schema for shortened URL
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "url" do
    field :slug, :string
    field :target, :string

    timestamps()
  end

  def changeset(url, attrs) do
    url
    |> cast(attrs, [:target, :slug])
    |> validate_required([:target, :slug])
    |> validate_target()
  end

  defp validate_target(changeset) do
    validate_change(changeset, :target, fn :target, target ->
      case URI.parse(target) do
        %URI{host: "" <> _, scheme: "" <> _} ->
          []
        %URI{scheme: nil} ->
          [{:target, "Invalid URL: missing scheme (ex: 'http://' or 'https://')"}]
      end
    end)
  end
end
