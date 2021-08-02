defmodule Om.Store do
  alias Ecto.Changeset
  alias Om.Repo
  alias Om.Store.Order
  alias Om.Store.Payment

  import Om.Store.Calculator

  def create_order(%{total: total} = params) do
    order_params = Map.put(params, :balance_due, total)

    %Order{}
    |> Order.changeset(order_params)
    |> Repo.insert()
  end

  def pay_order(%{amount: amount, order_id: order_id} = payment_params) do
    Repo.transaction(fn ->
      with {:ok, order} <- get_order(order_id),
           {:ok, new_balance_due} <- get_new_balance_due(order, amount) do
        {:ok, _} =
          order
          |> Changeset.change(%{balance_due: new_balance_due})
          |> Repo.update()

        {:ok, payment} =
          %Payment{}
          |> Payment.changeset(payment_params)
          |> Repo.insert()

        payment
      else
        {:error, err} -> Repo.rollback(err)
      end
    end)
  end

  defp get_order(order_id) do
    case Repo.get(Order, order_id)
         |> Repo.preload(:payments) do
      nil -> {:error, "order_not_found"}
      order -> {:ok, order}
    end
  end
end
