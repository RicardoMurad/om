defmodule On.Store.PaymentTest do
  use Om.DataCase

  alias Om.Store.Payment
  alias Ecto.Changeset

  @valid_payment %{
    amount: 10_000,
    applied_at: ~N[2021-01-01 23:00:07],
    note: "A foo payment"
  }

  describe "changeset/1" do
    test "it creates an order" do
      %Changeset{valid?: true, changes: changes} = %Payment{} |> Payment.changeset(@valid_payment)
      assert @valid_payment == changes
    end

    test "it refuses negative amount" do
      invalid_payment = %{@valid_payment | amount: -10}

      assert %{amount: ["must be greater than or equal to 0"]} ==
               %Payment{}
               |> Payment.changeset(invalid_payment)
               |> errors_on()
    end

    test "it refuses amount overflow" do
      invalid_payment = %{@valid_payment | amount: 100_000_000}

      assert %{amount: ["must be less than or equal to 10000000"]} ==
               %Payment{}
               |> Payment.changeset(invalid_payment)
               |> errors_on()
    end

    test "it requires applied_at date" do
      invalid_payment = Map.drop(@valid_payment, [:applied_at])

      assert %{applied_at: ["can't be blank"]} ==
               %Payment{}
               |> Payment.changeset(invalid_payment)
               |> errors_on()
    end
  end
end
