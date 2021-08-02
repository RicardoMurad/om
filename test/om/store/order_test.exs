defmodule On.Store.OrderTest do
  use Om.DataCase

  alias Om.Store.Order
  alias Ecto.Changeset

  @valid_order %{
    description: "This is a valid order",
    balance_due: 1_000,
    total: 10_123
  }

  describe "changeset/1" do
    test "it creates an order" do
      %Changeset{valid?: true, changes: changes} = %Order{} |> Order.changeset(@valid_order)
      assert @valid_order == changes
    end

    test "it refuses negative totals" do
      invalid_order = %{@valid_order | total: -10}

      assert %{total: ["must be greater than 0"]} ==
               %Order{}
               |> Order.changeset(invalid_order)
               |> errors_on()
    end

    test "it refuses max totals" do
      invalid_order = %{@valid_order | total: 11_000_000}

      assert %{total: ["must be less than or equal to 10000000"]} ==
               %Order{}
               |> Order.changeset(invalid_order)
               |> errors_on()
    end

    test "it validates negatives balance dues" do
      invalid_order = %{@valid_order | balance_due: -11}

      assert %{balance_due: ["must be greater than 0"]} ==
               %Order{}
               |> Order.changeset(invalid_order)
               |> errors_on()
    end

    test "it validates max balance dues" do
      invalid_order = %{@valid_order | balance_due: 15_000_000}

      assert %{balance_due: ["must be less than or equal to 10000000"]} ==
               %Order{}
               |> Order.changeset(invalid_order)
               |> errors_on()
    end

    test "it validates mix description size" do
      invalid_order = %{@valid_order | description: "foo"}

      assert %{description: ["should be at least 5 character(s)"]} ==
               %Order{}
               |> Order.changeset(invalid_order)
               |> errors_on()
    end

    test "it validates max description size" do
      big_title = :base64.encode(:crypto.strong_rand_bytes(1000))
      invalid_order = %{@valid_order | description: big_title}

      assert %{description: ["should be at most 100 character(s)"]} ==
               %Order{}
               |> Order.changeset(invalid_order)
               |> errors_on()
    end
  end
end
