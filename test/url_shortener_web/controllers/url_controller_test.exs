defmodule UrlShortenerWeb.UrlControllerTest do
  use UrlShortenerWeb.ConnCase

  @valid_target %{"url" => %{"target" => "http://google.com/calendar"}}
  @missing_scheme %{"url" => %{"target" => "google.com/calendar"}}
  @missing_host %{"url" => %{"target" => "https://"}}


  describe "initial load" do
    test "GET /", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "Enter the URL you'd like to shorten"
    end
  end

  describe "POST /" do
    test "valid URL", %{conn: conn} do
      conn = post(conn, "/", @valid_target)
      assert "/" = redir_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redir_path)
      assert html_response(conn, 200) =~ "created"
    end

    test "missing url scheme", %{conn: conn} do
      conn = post(conn, "/", @missing_scheme)
      assert html_response(conn, 200) =~ "missing scheme"
    end

    test "missing url host", %{conn: conn} do
      conn = post(conn, "/", @missing_host)
      assert html_response(conn, 200) =~ "missing host"
    end
  end

  describe "GET url" do
    setup [:create_url]
    test "redirects to the shortened url", %{conn: conn, url: %{target: target, slug: slug}} do
      conn = get(conn, "/x/#{slug}")
      assert ^target = redirected_to(conn, 302)
    end
  end

  describe "GET url not in db" do
    test "responds with error", %{conn: conn} do
      conn = get(conn, "/x/lsjdflih")
      assert "/" = redir_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redir_path)
      assert html_response(conn, 200) =~ "Could not find"
    end
  end

  defp create_url(_) do
    {:ok, url} = UrlShortener.Urls.create_url(%{"target" => "https://google.com/calendar"})
    %{url: url}
  end
end
