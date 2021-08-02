defmodule OmWeb.GraphQl.Schema.Store.Queries do
  use Absinthe.Schema.Notation

  alias OmWeb.GraphQl.Schema.Store.Resolver

  object :store_queries do
    field(:orders, list_of(:order)) do
      resolve(&Resolver.resolve_orders/3)
    end
  end
end
