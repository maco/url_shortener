defmodule UrlShortenerWeb.UrlController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Urls
  alias UrlShortener.Urls.Url

  def new(conn, _params) do
    changeset = Urls.change_url(%Url{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"url" => url_params}) do
    case Urls.create_url(url_params) do
      {:ok, url} ->
        conn
        |> put_flash(:info, "#{UrlShortenerWeb.Endpoint.url()}/x/#{url.slug} created")
        |> redirect(to: Routes.url_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"slug" => slug}) do
    case Urls.get_url(%{slug: slug}) do
      %Url{target: target} ->
        conn
        |> redirect(external: target)

      _ ->
        conn
        |> put_flash(:error, "Could not find corresponding target url")
        |> redirect(to: Routes.url_path(conn, :new))
    end
  end
end
