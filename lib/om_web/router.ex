defmodule OmWeb.Router do
  use OmWeb, :router

  alias OmeWeb.Graphql.Schema

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    forward "/graphl", Absinthe.Plug, schema: Schema
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: Schema
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: OmWeb.Telemetry
    end
  end
end