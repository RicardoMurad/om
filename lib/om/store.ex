defmodule Om.Store do
  alias Ecto.Changeset
  alias Om.Repo
  alias Om.Store.Order
  alias Om.Store.Payment

  import Ecto.Query

  def create_order(%{total: total} = params) do
    order_params = Map.put(params, :balance_due, total)

    %Order{}
    |> Order.changeset(order_params)
    |> Repo.insert()
  end

  def get_orders do
    from(o in Order,
      left_join: p in assoc(o, :payments),
      preload: [payments: p],
      order_by: :inserted_at
    )
    |> Repo.all()
  end

  def pay_order(%{amount: amount, order_id: order_id, id: payment_id} = payment_params) do
    Repo.transaction(fn ->
      with {:error, "payment_not_found"} <- get_payment(payment_id),
           {:ok, order} <- get_order(order_id),
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
        {:ok, %Payment{}} -> Repo.rollback("payment_already_processed")
      end
    end)
  end

  defp get_new_balance_due(%Order{balance_due: balance_due}, amount) do
    new_balance_due = balance_due - amount

    if new_balance_due >= 0 do
      {:ok, new_balance_due}
    else
      {:error, "payment_amount_over_limit"}
    end
  end

  defp get_order(order_id) do
    case Repo.get(Order, order_id)
         |> Repo.preload(:payments) do
      nil -> {:error, "order_not_found"}
      order -> {:ok, order}
    end
  end

  defp get_payment(payment_id) do
    case Repo.get(Payment, payment_id) do
      nil -> {:error, "payment_not_found"}
      payment -> {:ok, payment}
    end
  end
end
