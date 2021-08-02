defmodule Om.Store.Calculator do
  alias Om.Store.Order

  def get_new_balance_due(%Order{balance_due: balance_due}, amount) do
    new_balance_due = balance_due - amount

    if new_balance_due >= 0 do
      {:ok, new_balance_due}
    else
      {:error, "payment_amount_over_limit"}
    end
  end
end
