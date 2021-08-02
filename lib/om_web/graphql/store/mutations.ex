defmodule OmWeb.GraphQl.Schema.Store.Mutations do
  use Absinthe.Schema.Notation

  alias OmWeb.GraphQl.Schema.Store.Resolver

  object :store_mutations do
    field(:create_order, type: :order) do
      arg(:input, non_null(:order_input))
      resolve(&Resolver.create_order/3)
    end

    field(:create_payment, type: :payment) do
      arg(:input, non_null(:payment_input))
      resolve(&Resolver.create_payment/3)
    end
  end
end
