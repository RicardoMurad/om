defmodule On.Store.StoreTest do
  use Om.DataCase

  alias Om.Store
  alias Om.Store.Order

  import Om.Factory

  @valid_order %{
    description: "This is a valid order",
    total: 10_123
  }

  describe "create_order/1" do
    test "it creates an order" do
      assert {:ok, order} = Store.create_order(@valid_order)
      assert @valid_order.description == order.description
      assert @valid_order.total == order.balance_due
      assert @valid_order.total == order.total
    end

    test "it validates that initial balance due is allways equals total" do
      order = Map.put(@valid_order, :balance_due, 300)
      assert {:ok, order} = Store.create_order(order)
      assert @valid_order.total == order.balance_due
    end

    test "it validates order description field" do
      assert {:error, changeset} = Store.create_order(%{total: 1})

      assert %{description: ["can't be blank"]} == changeset |> errors_on()
    end

    test "it validates total and balance_due values" do
      invalid_order = %{@valid_order | total: -20}

      assert {:error, changeset} = Store.create_order(invalid_order)

      assert %{total: ["must be greater than 0"], balance_due: ["must be greater than 0"]} ==
               changeset |> errors_on()
    end
  end

  describe "pay_order/1" do
    test "it validades if payment amount is more than order balance_due" do
      %{id: order_id} = insert!(:order, balance_due: 1000)

      params = %{
        order_id: order_id,
        amount: 2000,
        note: "bit payment"
      }

      assert {:error, "payment_amount_over_limit"} == Store.pay_order(params)
    end

    test "it validades if payment amount is equal order balance_due" do
      %{id: order_id} = insert!(:order, balance_due: 1000)

      params = %{
        order_id: order_id,
        amount: 1000,
        note: "bit payment"
      }

      assert {:ok, payment} = Store.pay_order(params)
      assert payment.id
    end

    test "it validades if payment amount is less than order balance_due" do
      %{id: order_id} = insert!(:order, balance_due: 1000)

      params = %{
        order_id: order_id,
        amount: 10,
        note: "bit payment"
      }

      assert {:ok, payment} = Store.pay_order(params)
      assert payment.id

      new_order = Repo.get(Order, order_id)

      assert 990 == new_order.balance_due
    end
  end
end
