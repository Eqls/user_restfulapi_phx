defmodule UserRestfulapiPhxWeb.PageController do
  use UserRestfulapiPhxWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
