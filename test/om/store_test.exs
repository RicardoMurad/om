defmodule On.Store.StoreTest do
  use Om.DataCase

  alias Om.Store

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
end
