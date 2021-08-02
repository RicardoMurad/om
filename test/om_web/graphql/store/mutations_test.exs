defmodule OmWeb.GraphQl.Schema.Store.MutationsTest do
  use OmWeb.ConnCase

  import Om.Factory

  @create_order_mutation """
  mutation($input:OrderInput!) {
    createOrder(input: $input) {
      id
      balanceDue
      description
      total
      insertedAt
    }
  }
  """

  @create_payment_mutation """
  mutation($input: PaymentInput!) {
    createPayment(input:$input) {
      id
      amount
      appliedAt
      note
    }
  }
  """

  @valid_input %{
    total: 1_000,
    description: "This is a order"
  }

  describe "create_order" do
    test "it creates an order", %{conn: conn} do
      assert %{
               "data" => %{
                 "createOrder" => %{
                   "balanceDue" => 1000,
                   "description" => "This is a order",
                   "id" => result_id,
                   "insertedAt" => _,
                   "total" => 1000
                 }
               }
             } =
               run_graphql(conn,
                 query: @create_order_mutation,
                 variables: %{"input" => @valid_input}
               )

      assert result_id
    end

    test "it validates required fields", %{conn: conn} do
      assert %{
               "errors" => [
                 %{
                   "locations" => [%{"column" => 15, "line" => 2}],
                   "message" =>
                     "Argument \"input\" has invalid value $input.\nIn field \"total\": Expected type \"Int!\", found null.\nIn field \"description\": Expected type \"String!\", found null."
                 }
               ]
             } ==
               run_graphql(conn,
                 query: @create_order_mutation,
                 variables: %{"input" => %{}}
               )
    end
  end

  describe "create_payment" do
    test "should create a payment", %{conn: conn} do
      %{id: order_id} = insert!(:order, balance_due: 1000)

      params = %{
        order_id: order_id,
        amount: 1000,
        note: "This litle note"
      }

      assert %{
               "data" => %{
                 "createPayment" => %{
                   "amount" => 1000,
                   "appliedAt" => applied_at,
                   "id" => payment_id,
                   "note" => "This litle note"
                 }
               }
             } =
               run_graphql(conn,
                 query: @create_payment_mutation,
                 variables: %{"input" => params}
               )

      assert payment_id
      assert applied_at
    end

    test "it tries to pay over limit", %{conn: conn} do
      %{id: order_id} = insert!(:order, balance_due: 1000)

      params = %{
        order_id: order_id,
        amount: 1000,
        note: "This litle note"
      }

      assert %{
               "data" => %{
                 "createPayment" => %{
                   "amount" => 1000,
                   "appliedAt" => _,
                   "id" => _,
                   "note" => "This litle note"
                 }
               }
             } =
               run_graphql(conn,
                 query: @create_payment_mutation,
                 variables: %{"input" => params}
               )

      assert %{
               "data" => %{"createPayment" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 3, "line" => 2}],
                   "message" => "payment_amount_over_limit",
                   "path" => ["createPayment"]
                 }
               ]
             } ==
               run_graphql(conn,
                 query: @create_payment_mutation,
                 variables: %{"input" => params}
               )
    end

    test "it to pay an invalid order", %{conn: conn} do
      order_id = UUID.uuid4()

      params = %{
        order_id: order_id,
        amount: 1000,
        note: "This litle note"
      }

      assert %{
               "data" => %{"createPayment" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 3, "line" => 2}],
                   "message" => "order_not_found",
                   "path" => ["createPayment"]
                 }
               ]
             } ==
               run_graphql(conn,
                 query: @create_payment_mutation,
                 variables: %{"input" => params}
               )
    end
  end
end
