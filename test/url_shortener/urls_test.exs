defmodule UrlShortener.UrlsTest do
  import Ecto.Query, only: [from: 2]

  use UrlShortenerWeb.ConnCase

  alias UrlShortener.Urls
  alias UrlShortener.Urls.Url
  alias UrlShortener.Repo

  @url1 "https://google.com/calendar"
  @url2 "https://twitter.com/getstord"

  describe "generate slug" do
    test "when it doesn't collide" do
      slug = Urls.generate_slug(@url1)
      assert "C8ryvm" = slug
    end

    test "uses longer slug when it collides" do
      Repo.insert(%Url{target: @url2, slug: "C8ryvm"})
      slug = Urls.generate_slug(@url1)
      assert "C8ryvmH" = slug
    end
  end

  describe "create url" do
    test "creates a short url" do
      refute Repo.exists?(from u in Url, where: u.target == @url1)
      Urls.create_url(%{"target" => @url1})
      assert Repo.exists?(from u in Url, where: u.target == @url1)
    end

    test "when it's already in the database" do
      Urls.create_url(%{"target" => @url1})
      assert Repo.exists?(from u in Url, where: u.target == @url1)
      Urls.create_url(%{"target" => @url1})
      assert Repo.one(from u in Url, where: u.target == @url1)
    end
  end
end
