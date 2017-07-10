defmodule SunnyMap.PageController do
  use SunnyMap.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
