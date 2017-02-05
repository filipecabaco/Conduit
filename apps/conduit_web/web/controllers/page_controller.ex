defmodule ConduitWeb.PageController do
  use ConduitWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
