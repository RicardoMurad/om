defmodule OmWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use OmWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import OmWeb.ConnCase

      alias OmWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint OmWeb.Endpoint

      def run_graphql(conn, options) do
        conn
        |> post(
          "/graphql",
          build_query(options[:query], options[:variables])
        )
        |> json_response(200)
      end

      defp build_query(query, variables) do
        %{
          "query" => query,
          "variables" => variables
        }
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Om.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Om.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
