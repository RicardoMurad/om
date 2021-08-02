defmodule Om.Store do
  alias Om.Store.Order
  alias Om.Repo

  def create_order(%{total: total} = params) do
    order_params = Map.put(params, :balance_due, total)

    %Order{}
    |> Order.changeset(order_params)
    |> Repo.insert()
  end
end
