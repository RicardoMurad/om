defmodule On.Store.PaymentTest do
  use Om.DataCase

  import Om.Factory

  alias Om.Store.Payment
  alias Ecto.Changeset

  setup do
    order = insert!(:order)

    valid_payment = %{
      id: UUID.uuid4(),
      amount: 10_000,
      note: "A foo payment",
      order_id: order.id
    }

    {:ok, %{valid_payment: valid_payment}}
  end

  describe "changeset/1" do
    test "it creates an order", %{valid_payment: valid_payment} do
      %Changeset{valid?: true, changes: changes} = %Payment{} |> Payment.changeset(valid_payment)
      assert valid_payment == changes
    end

    test "it refuses negative amount", %{valid_payment: valid_payment} do
      invalid_payment = %{valid_payment | amount: -10}

      assert %{amount: ["must be greater than or equal to 0"]} ==
               %Payment{}
               |> Payment.changeset(invalid_payment)
               |> errors_on()
    end

    test "it refuses amount overflow", %{valid_payment: valid_payment} do
      invalid_payment = %{valid_payment | amount: 100_000_000}

      assert %{amount: ["must be less than or equal to 10000000"]} ==
               %Payment{}
               |> Payment.changeset(invalid_payment)
               |> errors_on()
    end
  end
end
