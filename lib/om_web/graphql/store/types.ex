defmodule OmWeb.GraphQl.Schema.Store.Types do
  use Absinthe.Schema.Notation

  object :order do
    field(:id, non_null(:uuid4))
    field(:description, non_null(:string))
    field(:balance_due, non_null(:integer))
    field(:total, non_null(:integer))
    field(:inserted_at, non_null(:string))
    field(:payments, list_of(:payment))
  end

  object :payment do
    field(:id, non_null(:uuid4))
    field(:amount, non_null(:integer))
    field(:note, non_null(:string))

    field(:applied_at, non_null(:string)) do
      resolve(fn payment, _, _ -> {:ok, payment.inserted_at} end)
    end
  end

  # # input objects

  input_object :order_input do
    field(:description, non_null(:string))
    field(:total, non_null(:integer))
    field(:total, non_null(:integer))
  end

  input_object :payment_input do
    field(:order_id, non_null(:uuid4))
    field(:amount, non_null(:integer))
    field(:note, :string)
  end
end
