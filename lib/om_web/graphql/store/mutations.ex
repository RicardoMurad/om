defmodule OmWeb.GraphQl.Schema.Store.Mutations do
  use Absinthe.Schema.Notation

  object :store_mutations do
    field(:create_order, type: :order) do
      arg(:input, non_null(:order_input))
      resolve(fn _, _, _ -> {:ok, %{}} end)
    end
  end
end
