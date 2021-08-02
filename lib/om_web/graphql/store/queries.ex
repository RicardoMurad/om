defmodule OmWeb.GraphQl.Schema.Store.Queries do
  use Absinthe.Schema.Notation

  object :store_queries do
    field(:orders, list_of(:order)) do
      resolve(fn _, _, _ -> {:ok, []} end)
    end
  end
end
