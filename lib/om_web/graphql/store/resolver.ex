defmodule OmWeb.GraphQl.Schema.Store.Resolver do
  alias Om.Store

  def create_order(_, %{input: order_input}, _), do: Store.create_order(order_input)

  def create_payment(_, %{input: payment_input}, _), do: Store.pay_order(payment_input)
end
