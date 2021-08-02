defmodule OmWeb.GraphQl.Schema.Store.QueriesTest do
  use OmWeb.ConnCase

  import Om.Factory

  @get_orders_query """
  query {
    orders {
      id
      description
      balanceDue
      payments {
        amount
        id
        appliedAt
        note
      }
    }
  }
  """

  describe "get_orders" do
    test "it query orders", %{conn: conn} do
      first = insert!(:order)
      second = insert!(:order)

      insert!(:payment, order_id: first.id)
      insert!(:payment, order_id: first.id)

      assert %{
               "data" => %{
                 "orders" => [
                   %{
                     "balanceDue" => 1000,
                     "description" => "Factory order",
                     "id" => _,
                     "payments" => [
                       %{
                         "amount" => 100,
                         "appliedAt" => _,
                         "id" => _,
                         "note" => "payment Factory"
                       },
                       %{
                         "amount" => 100,
                         "appliedAt" => _,
                         "id" => _,
                         "note" => "payment Factory"
                       }
                     ]
                   },
                   %{
                     "balanceDue" => 1000,
                     "description" => "Factory order",
                     "id" => _,
                     "payments" => []
                   }
                 ]
               }
             } ==
               run_graphql(conn, query: @get_orders_query)
    end
  end
end
