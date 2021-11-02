defmodule UrlShortener.Urls do
  @moduledoc """
  Urls context
  """

  alias UrlShortener.Repo
  alias UrlShortener.Urls.Url

  def change_url(%Url{} = url) do
    Url.changeset(url, %{})
  end

  def create_url(%{"target" => target} = attrs \\ %{}) do
    case get_url(%{target: target}) do
      %Url{slug: _} = url ->
        # If the target URL is already in the database, return it
        {:ok, url}

      _ ->
        %Url{slug: generate_slug(target)}
        |> Url.changeset(attrs)
        |> Repo.insert()
    end
  end

  def get_url(params) do
    Repo.get_by(Url, params)
  end

  def generate_slug(target) do
    :crypto.hash(:sha256, target)
    |> Base.encode64()
    |> slice_unique(6)
  end

  defp slice_unique(b64, len) do
    slug = String.slice(b64, 0, len)

    if Repo.get_by(Url, %{slug: slug}) do
      # add another bit
      slice_unique(b64, len + 1)
    else
      slug
    end
  end
end
