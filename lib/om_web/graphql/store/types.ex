defmodule OmWeb.GraphQl.Schema.Store.Types do
  use Absinthe.Schema.Notation

  object :order do
    field(:id, non_null(:uuid4))
    field(:description, non_null(:string))
    field(:balance_due, non_null(:integer))
    field(:total, non_null(:integer))
  end

  # # input objects

  input_object :order_input do
    field(:description, non_null(:string))
    field(:total, non_null(:integer))
    field(:total, non_null(:integer))
  end
end
